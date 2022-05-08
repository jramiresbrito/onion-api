# BLUE ONION API

This API was developed as part of the [Blue Onion's](https://www.blueonionlabs.com/) Software Engineer take home test.

## Dependencies version

- Ruby v2.6.6
- Bundler v.2.2.31
- Rails v6.0.4.8

## Setup

This software was created only to be used in development environment.
Although it is very easy to add, test and production environments are not available.

In order to run the software you will need docker and docker-compose which can be found in:

- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)

A script to manage the containers is available. Therefore, after installing
both **docker** and **docker-compose**, run the following command:

```sh
./scripts/development start
```

> Obs: all commands may require sudo if your user does not belong
> to the [docker group](https://docs.docker.com/install/linux/linux-postinstall/)

To list all running containers, run:

```sh
docker ps
```

You should see the following container:

- onion-api-rails - the main container that runs the rails server. It binds
  the port 3000 from localhost.
