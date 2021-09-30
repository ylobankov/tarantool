# Download and print logs of a workflow run where an error occurred

This action downloads logs of a workflow run by the provided link and prints 
those logs where an error occurred.

## How to use

Add the following code to the `steps` section in your workflow file after the 
repo checkout is done:

```
  - uses: ./.github/actions/print-err-logs
    with:
      logs_url: ${{ env.LOGS_URL }}
```
