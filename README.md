# Polling for status with a timeout

This action makes a GET request to a given URL until the status is `complete` or `failed`
Used after launching an action that executes asynchronously and polling for that action's status
Initially created for checking if a kubernetes deployment is complete

## Inputs

### `url`

The URL to poll

### `timeout`

Timeout before giving up in seconds

### `interval`

Interval between polling in seconds

## Example usage
```
uses: cheerz/poll_status@v1
with:
  url: "https://www.example.com/deployments/1"
  timeout: 20
  interval: 5
```

This script expects a json response from the polling url in the following format:

```
{
  status: "complete"/"failed"
}
```

Script exit with 1 when status is `failed` and 0 when `complete`
Exit with 1 if timeout reached before receiving `failed` or `complete` as status