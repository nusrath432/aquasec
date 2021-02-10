FROM ubuntu:18.04
LABEL maintainer="nusrath432@rediffmail.com"
RUN apt-get update
RUN apt-get install -y nginx
ENTRYPOINT [“/usr/sbin/nginx”,”-g”,”daemon off;”]
EXPOSE 80
# My comment
