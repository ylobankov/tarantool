# Trigger a workflow from another workflow

The objective of this action is to allow chained workflows. The action triggers 
the specified workflow via GitHub API and waits for its run to finish. 
A workflow can be triggered by this action if it is configured to run on the 
`workflow_dispatch` event.

## How to use

Add the following code to the `steps` section in your workflow file after the 
repo checkout is done:

```
  - uses: ./.github/actions/trigger-workflow
    with:
      workflow_id: ${{ env.WORKFLOW_ID }}
      inputs: |
        {
          "a": "1",
          "b": "2",
          "c": "3"
        }
```
