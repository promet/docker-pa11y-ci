FROM node:11
#
# This container uses the current version of pa11y (version 5.1.0 as of this writing) but downgrades
# to pa11y-ci version 1.3.1.  Versions 2.0.0 and above are failing to load Chromium, and I have not
# been able to get this resolved other than to downgrade the pa11y command line tool version
#
# A sample docker-compose file for this container is as follows:
#
# version: '3.4'
# services:
#   pa11y:
#     image: promet/docker-pa11y-ci
#     volumes:
#        - ./config.json:/workspace/config.json
#
#
# A config.json example file is as follows (note as of this writing www.google.com fails testing, 
# while the other two URLs pass):
#
# {
#	"chromeLaunchConfig": {
#        "executablePath": "/usr/bin/google-chrome-stable",
#        "ignoreHTTPSErrors": false
#    },
#    "urls": [
#        "http://pa11y.org/",
#        "http://pa11y.org/contributing",
#        "https://www.google.com"
#    ]
# }
#
# To use this command line tool, execute the following from the command line with docker-compose
# (assumes this container is set up as a service named "pa11y"):
#
# docker-compose run pa11y /bin/bash -c "pa11y-ci --config /workspace/config.json"
#

LABEL maintainer="Lisa Ridley <lisa@prometsource.com>"

RUN apt-get update && apt-get install -y curl wget apt-transport-https \
	&& wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
	&& apt-get install -y wget unzip fontconfig locales gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget \
	&& npm install -g pa11y-ci@1.3.1 depcheck --unsafe-perm \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y \
    && rm -rf /src/*.deb

WORKDIR /workspace
