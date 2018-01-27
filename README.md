# Yahoo Integration

##NOTE:
NuRelm staff contributions to their Open Source integrations with FlowLink
allowed for this project to be a reality

## Overview

## Developer Environment Setup
Perform the following commands to setup your development environment:

```sh
$ docker rm -f yahoo-integration-container
$ docker build -t yahoo-integration .
$ docker run -t -e VIRTUAL_HOST=yahoo-integration.flowlink.io -e RAILS_ENV=development -v $PWD:/app -p 3001:5000 --name yahoo-integration-container yahoo-integration
```

Then access the local integration at http://localhost:3001

## Webhooks

The following webhooks are implemented. For all 'get_' webhooks, a
'yahoo_id' field is return that use used to tie a Flowlink object to its
corresponding Yahoo object.

* **get_league**: Retrieves one league based on league ID given

### get_league

The `get_league` hook returns league information based on a league id and the
sport. The following is the JSON needed for this hook.

```json
{
  "parameters": {
    "yahoo_host": "www.yahooexample.com",
    "yahoo_key": "1234",
    "yahoo_secret": "5678",
    "league_id": "9001",
    "sport": "nhl"
  }
}
```
