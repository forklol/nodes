## Licenced under The MIT License (MIT)
## Copyright (c) 2015 Adrian Macneil

FROM debian:stretch-slim

RUN groupadd -r bitcoin-bch && useradd -r -m -g bitcoin-bch bitcoin-bch

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/*

ENV BITCOIN_VERSION 0.14.6
ENV BITCOIN_URL https://download.bitcoinabc.org/0.14.6/linux/bitcoin-0.14.6-x86_64-linux-gnu.tar.gz
ENV BITCOIN_SHA256 9f37b8ec36a37944b016bbbf07340adb8ba644abb897b2d2e0edeb99ccf709c0

# install bitcoin binaries
RUN set -ex \
	&& BITCOIN_DIST=$(basename $BITCOIN_URL) \
	&& wget -qO $BITCOIN_DIST $BITCOIN_URL \
	&& echo "$BITCOIN_SHA256 $BITCOIN_DIST" | sha256sum -c - \
	&& tar -xzvf $BITCOIN_DIST -C /usr/local --strip-components=1 --exclude=*-qt \
	&& rm bitcoin*

# create data directory
ENV BITCOIN_DATA /data-bch
RUN mkdir $BITCOIN_DATA \
	&& chown -R bitcoin-bch:bitcoin-bch $BITCOIN_DATA \
	&& ln -sfn $BITCOIN_DATA /home/bitcoin-bch/.bitcoin \
	&& chown -h bitcoin-bch:bitcoin-bch /home/bitcoin-bch/.bitcoin
VOLUME /data-bch

COPY docker-entrypoint.sh /entrypoint.sh
COPY bitcoin.conf $BITCOIN_DATA/bitcoin.conf
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8332
CMD ["bitcoind", "-dbcache=2048"]

