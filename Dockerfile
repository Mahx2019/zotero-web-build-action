FROM alpine:3
ARG TAG=master
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories &&\
	apk update &&\
	apk add --no-cache nodejs npm git rsync perl

RUN npm config set registry https://registry.npmmirror.com &&\
	npm config get registry &&\
	npm -v && node -v

WORKDIR /zotero
COPY entrypoint.sh /zotero/

RUN cd /zotero && \
	mkdir config && \
	chmod +x entrypoint.sh

RUN git clone https://github.com/zotero/web-library && \
	cd web-library && \
	git checkout $TAG && \
	npm install

RUN cd /zotero/web-library && npm run build

EXPOSE 8001/TCP
VOLUME /zotero/config
ENTRYPOINT ["/zotero/entrypoint.sh"]
