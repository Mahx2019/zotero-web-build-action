FROM alpine:3
ARG TAG=master
RUN apk update &&\
	apk add --no-cache nodejs npm git git-lfs rsync perl zip python3 curl wget

RUN npm -v && node -v

WORKDIR /zotero
COPY entrypoint.sh /zotero/

RUN cd /zotero && \
	mkdir config && \
	chmod +x entrypoint.sh

RUN git clone --recursive https://github.com/zotero/web-library.git && \
	cd web-library && \
	npm ci

RUN cd /zotero/web-library && npm run build

EXPOSE 8001/TCP
VOLUME /zotero/config
ENTRYPOINT ["/zotero/entrypoint.sh"]
