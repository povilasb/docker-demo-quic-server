FROM debian:jessie

MAINTAINER Povilas Balciunas <balciunas90@gmail.com>

RUN apt-get update
RUN apt-get install -y git curl python g++ pkg-config libnss3

# Compile quic_server
RUN git clone https://github.com/google/proto-quic /tmp/proto-quic
ADD disable_certificate_verification.patch /tmp/
RUN patch /tmp/proto-quic/src/net/cert/cert_verify_proc_nss.cc \
	/tmp/disable_certificate_verification.patch

ENV PATH=$PATH:/tmp/proto-quic/depot_tools
RUN cd /tmp/proto-quic/src && gclient runhooks && \
	ninja -C out/Release quic_client quic_server net_unittests

# Install quic_server
RUN mkdir -p /opt/quic
RUN cp /tmp/proto-quic/src/out/Release/quic_server /opt/quic/
RUN cp /tmp/proto-quic/src/out/Release/quic_client /opt/quic/

# Setup quic_server
ADD quic-data /tmp/quic-data
ADD certs /tmp/certs
RUN cd /tmp/certs && ./generate-certs.sh

CMD cd /opt/quic && \
	./quic_server --port=8123 \
	--certificate_file=/tmp/certs/out/leaf_cert.pem \
	--key_file=/tmp/certs/out/leaf_cert.pkcs8 \
	--quic_in_memory_cache_dir=/tmp/quic-data/www.example.org --v=1
