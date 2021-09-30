#!/usr/bin/env python3

# Trigger a workflow and wait for its run to finish.

import argparse
import json
import logging
import sys
import time

import requests

LOG = logging.getLogger(__name__)
LOG.setLevel(logging.INFO)
LOG.addHandler(logging.StreamHandler())

GH_API_BASE_URL = 'https://api.github.com'
WR_SEARCH_TIMEOUT = 60  # in seconds
WR_SEARCH_INTERVAL = 1  # in seconds
WR_SEARCH_NUMBER = 100


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--token',
        required=True,
        help='The GitHub token to use for making API requests',
    )
    parser.add_argument(
        '--repo',
        required=True,
        help=(
            'The full name of the repository like <owner>/<name> '
            'where the workflow is contained'
        ),
    )
    parser.add_argument(
        '--ref',
        required=True,
        help='The reference of the workflow, can be a branch or tag',
    )
    parser.add_argument(
        '--head-sha',
        required=True,
        help=(
            'The head commit SHA of the workflow reference, it is used for '
            'searching the workflow run'
        ),
    )
    parser.add_argument(
        '--workflow-id', required=True, help='The file name of the workflow'
    )
    parser.add_argument(
        '--inputs',
        required=True,
        help='Inputs to pass to the workflow, must be a JSON string',
    )
    parser.add_argument(
        '--wait-timeout',
        type=int,
        required=True,
        help='The timeout in seconds to wait for the workflow run to finish',
    )
    parser.add_argument(
        '--wait-interval',
        type=int,
        required=True,
        help=(
            'The interval in seconds between requests to check '
            'the workflow run is finished'
        ),
    )
    parser.add_argument(
        '--propagate',
        action='store_true',
        help='Exit with 1 if the workflow run is not succeeded',
    )

    return parser.parse_args()


def get_error_message(response):
    return (
        f"Reason: {response.reason}, Status code: {response.status_code}, "
        f"Content: {response.text}"
    )


def get_workflow_run(workflow_url, headers, head_sha, last_run_number):
    end_time = time.time() + WR_SEARCH_TIMEOUT
    while time.time() < end_time:
        # Make a request to get all workflow runs.
        response = requests.get(f"{workflow_url}/runs", headers=headers)
        assert response.ok, get_error_message(response)

        # There may be a situation when the workflow run is not on the list yet.
        # It appears on the list not immediately. If the list is big enough
        # (thousands of workflow runs), it will take a while to process this
        # list. So we get the last N workflow runs and search our workflow run
        # among them. If the list length < N, it's ok.
        workflow_runs = response.json()['workflow_runs'][:WR_SEARCH_NUMBER]
        if workflow_runs:
            # Try to catch our workflow run.
            for workflow_run in workflow_runs:
                if (
                    workflow_run['status'] != 'completed'
                    and workflow_run['head_sha'] == head_sha
                    and workflow_run['run_number'] != last_run_number
                ):
                    return workflow_run

        time.sleep(WR_SEARCH_INTERVAL)
    else:
        raise TimeoutError(
            f"Unable to find the corresponding workflow run within "
            f"{WR_SEARCH_TIMEOUT} seconds. Probably, the workflow was not "
            f"started for some reason"
        )


def main(args):
    actions_url = f"{GH_API_BASE_URL}/repos/{args.repo}/actions"
    workflow_url = f"{actions_url}/workflows/{args.workflow_id}"

    headers = {
        'accept': 'application/vnd.github.v3+json',
        'authorization': f"bearer {args.token}",
    }
    data = {'ref': args.ref, 'inputs': json.loads(args.inputs)}

    # Make a request to get all workflow runs.
    response = requests.get(f"{workflow_url}/runs", headers=headers)
    assert response.ok, get_error_message(response)

    # Get the last workflow run. It will be needed later for searching our
    # future workflow run. The workflow runs are sorted and the last run is
    # the first on the list.
    last_run_number = response.json()['workflow_runs'][0]['run_number']

    # Make a request to trigger the workflow.
    response = requests.post(
        f"{workflow_url}/dispatches", headers=headers, data=json.dumps(data)
    )
    assert response.ok, get_error_message(response)

    # Triggering a workflow is an async operation. The best thing we can do is
    # to poll the list of workflow runs and catch our run when it will appear on
    # the list.
    workflow_run = get_workflow_run(
        workflow_url, headers, args.head_sha, last_run_number
    )

    LOG.info(f"::set-output name=run_id::{workflow_run['id']}")
    LOG.info(f"::set-output name=run_url::{workflow_run['html_url']}")
    LOG.info(f"The workflow run ID is {workflow_run['id']}")
    LOG.info(f"The workflow run URL is {workflow_run['html_url']}")

    # Wait for the workflow run to finish.
    end_time = time.time() + args.wait_timeout
    while time.time() < end_time:
        # Make a request to get the workflow run.
        response = requests.get(workflow_run['url'], headers=headers)
        assert response.ok, get_error_message(response)

        response = response.json()
        if response['status'] == 'completed':
            # Make a request to get the link to download the workflow run logs.
            logs_response = requests.get(response['logs_url'], headers=headers)
            assert logs_response.ok, get_error_message(logs_response)

            LOG.info(
                f"::set-output name=run_conclusion::{response['conclusion']}"
            )
            LOG.info(f"::set-output name=run_logs_url::{logs_response.url}")
            LOG.info(
                f"The workflow run {workflow_run['html_url']} has "
                f"finished. Status: {response['status']}. "
                f"Conclusion: {response['conclusion']}"
            )

            if response['conclusion'] != 'success' and args.propagate:
                return 1

            return 0

        LOG.info(
            f"Waiting for the workflow run {workflow_run['html_url']} to "
            f"finish. Sleeping for {args.wait_interval} seconds ..."
        )
        time.sleep(args.wait_interval)
    else:
        response = requests.post(
            f"{workflow_run['url']}/cancel", headers=headers
        )
        assert response.ok, get_error_message(response)

        raise TimeoutError(
            f"The workflow run {workflow_run['html_url']} didn't finish "
            f"within {args.wait_timeout} seconds and was canceled"
        )


if __name__ == '__main__':
    sys.exit(main(parse_args()))
