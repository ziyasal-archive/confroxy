FROM nginx:latest


#Install Curl
RUN apt-get update -qq && apt-get -y install curl && apt-get install unzip

#Install Consul Template (v0.15.0)
RUN curl -sS https://releases.hashicorp.com/consul-template/0.15.0/consul-template_0.15.0_linux_amd64.zip > consul.zip
RUN unzip consul.zip -d /usr/local/bin

#Setup Consul Template Files
RUN mkdir /etc/consul-templates

COPY nginx.ctmpl /etc/consul-templates/
ENV NGINX_APP_CTMPL_FILE /etc/consul-templates/nginx.ctmpl

#Setup Nginx File
RUN rm -v /etc/nginx/conf.d/*
#ADD nginx.conf /etc/nginx/nginx.conf  -- skipped now!

#Setup Nginx File for app
COPY app.conf /etc/nginx/conf.d/
ENV NGINX_APP_FILE /etc/nginx/conf.d/app.conf

#Default Variables
ENV CONSUL consul:8500
ENV SERVICE consul-8500

CMD service nginx start & /usr/sbin/nginx -c /etc/nginx/nginx.conf \
& CONSUL_TEMPLATE_LOG=debug consul-template \
  -consul=$CONSUL \
  -template "$NGINX_APP_CTMPL_FILE:$NGINX_APP_FILE:/usr/sbin/nginx -s reload  || true";