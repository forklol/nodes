## Licenced under The MIT License (MIT)
## Copyright (c) 2015 Adrian Macneil

FROM debian:stretch-slim

RUN groupadd -r bitcoin-btc && useradd -r -m -g bitcoin-btc bitcoin-btc

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

ENV BITCOIN_VERSION 0.14.2
ENV BITCOIN_URL https://bitcoin.org/bin/bitcoin-core-0.14.2/bitcoin-0.14.2-x86_64-linux-gnu.tar.gz
ENV BITCOIN_SHA256 20acc6d5d5e0c4140387bc3445b8b3244d74c1c509bd98f62b4ee63bec31a92b
ENV BITCOIN_ASC_URL https://bitcoin.org/bin/bitcoin-core-0.14.2/SHA256SUMS.asc
ENV BITCOIN_PGP_KEY 01EA5486DE18A882D4C2684590C8019E36C2E964

# install bitcoin binaries
RUN set -ex \
	&& BITCOIN_DIST=$(basename $BITCOIN_URL) \
	&& wget -qO $BITCOIN_DIST $BITCOIN_URL \
	&& echo "$BITCOIN_SHA256 $BITCOIN_DIST" | sha256sum -c - \
	&& gpg --keyserver keyserver.ubuntu.com --recv-keys $BITCOIN_PGP_KEY \
	&& wget -qO bitcoin.asc $BITCOIN_ASC_URL \
	&& gpg --verify bitcoin.asc \
	&& tar -xzvf $BITCOIN_DIST -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm bitcoin*

# create data directory
ENV BITCOIN_DATA /data
RUN mkdir $BITCOIN_DATA \
	&& chown -R bitcoin-btc:bitcoin-btc $BITCOIN_DATA \
	&& ln -sfn $BITCOIN_DATA /home/bitcoin-btc/.bitcoin \
	&& chown -h bitcoin-btc:bitcoin-btc /home/bitcoin-btc/.bitcoin
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8332
CMD ["bitcoind", "-dbcache=2048"]


