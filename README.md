# Pa11y CI Command Line tool in a Docker container

[![Build Status](https://travis-ci.org/promet/docker-pa11y-ci.svg?branch=develop)](https://travis-ci.org/promet/docker-pa11y-ci)

This repo contains the build for the Promet maintained docker container `promet/docker-pa11y-ci`.

## Background Information

This container uses the current version of pa11y (version 5.1.0 as of this writing) but downgrades to pa11y-ci version 1.3.1.  Versions 2.0.0 and above are failing to load Chromium, and I have not been able to get this resolved other than to downgrade the pa11y command line tool version.

## Use

### Sample docker-compose entry

A sample docker-compose file for this container is as follows:

```
version: '3.4'
services:
  pa11y:
    image: promet/docker-pa11y-ci
    volumes:
       - ./config.json:/workspace/config.json
```

### Sample config.json

The pa11y-ci command line tool can take a config.json file that contains basic configuration information, and a list of URLs to test.  This repo contains a sample config.json that execute tests against the following URLs:

* http://pa11y.org
* http://pa11y.org/contributing
* https://www.google.com

A config.json example file is as follows (note as of this writing www.google.com fails testing, while the other two URLs pass) that uses Google Chrome for browser testing, and tests the above list of URLs against WCAG 2AA standards:

```javascript
{
	"defaults": {
		"standard": "WCAG2AA"
	},
	"chromeLaunchConfig": {
        "executablePath": "/usr/bin/google-chrome-stable",
        "ignoreHTTPSErrors": false
    },
    "urls": [
        "http://pa11y.org/",
        "http://pa11y.org/contributing",
        "https://www.google.com"
    ]
}
```

### Command Line execution using Docker Compose

To use this command line tool, execute the following from the command line with docker-compose (assumes this container is set up as a service named "pa11y"):

```docker-compose run pa11y /bin/bash -c "pa11y-ci --config /workspace/config.json"```
