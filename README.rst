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

Adding other kinds of files
===========================

To make the client query for different kinds of files, like videos or images,
copy the requisite file to the quic-data/www.example.org/ folder and prepend the headers::

    $ cat index.html lena30.jpg > lena.jpg

Where `lena30.jpg` is your image file and `index.html` is the file already present.

Next, modify two of the parameters, the `Content-Length` and the `X-Original-Url` as::

    X-Original-Url: https://www.example.org/lena.jpg
    Content-Length: 30371

Make sure to do a `make image` after doing this to ensure caching of these new files in your `/tmp/quic-data`
Also, pull the above url while querying with the client.
