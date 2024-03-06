FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://code.antopie.org/miraty/libreqr.git && \
    cd libreqr && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM php:alpine AS build

RUN apk add libpng-dev zlib-dev && \
    docker-php-ext-install gd

FROM php:alpine

WORKDIR /libreqr
COPY --from=base /git/libreqr .
COPY --from=build /usr/local/lib/php/extensions /usr/local/lib/php/extensions
RUN apk add --no-cache libpng && \
    docker-php-ext-enable gd
EXPOSE 80
CMD [ "php", "-S", "0.0.0.0:80" ]
