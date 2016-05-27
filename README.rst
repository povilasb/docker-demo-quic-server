=====
About
=====

This repo contains a recipe to build Docker image for demo QUIC server
from https://github.com/google/proto-quic.

Usage
=====

Building Docker Container
=========================

Build image::

    $ make image

Start a container::

    $ make container

This will start a new QUIC server instance which is listening on **8123**
port.
This container serves some static content from
`quic-data/www.example.org/index.html`.

Querying server
===============

The way you query using demo quic client is::

    $ ./quic_client --host=172.17.0.2 --port=8123 https://www.example.org

Where `172.17.0.2` is Docker container IP address.

There's also a `quic_client` inside the container.
You can use it likes this::

    $ docker exec -it demo-quic-server /opt/quic/quic_client --host=localhost --port=8123 https://www.example.org

If you'd like to query using chrome, look at:
https://www.chromium.org/quic/playing-with-quic
