FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY . .

RUN flutter config --enable-web
RUN flutter pub get
RUN flutter build web

FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/build/web /usr/share/nginx/html

RUN chmod -R g=u /var/cache/nginx \
    && chmod -R g=u /var/run \
    && chmod -R g=u /etc/nginx \
    && chmod -R g=u /usr/share/nginx/html

EXPOSE 8080

CMD ["nginx","-g","daemon off;"]
