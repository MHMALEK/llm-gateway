FROM nginx:1.27-alpine

COPY docker-entrypoint.d/40-proxy-auth.sh /docker-entrypoint.d/40-proxy-auth.sh
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template

RUN chmod +x /docker-entrypoint.d/40-proxy-auth.sh
