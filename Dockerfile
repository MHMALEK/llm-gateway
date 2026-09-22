FROM nginx:1.27-alpine

COPY docker-entrypoint.d/15-proxy-auth.envsh /docker-entrypoint.d/15-proxy-auth.envsh
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template
