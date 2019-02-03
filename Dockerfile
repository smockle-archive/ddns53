FROM alpine

RUN apk -v --update add \
  bind-tools \
  python \
  py-pip \
  groff \
  less \
  mailcap \
  && \
  pip install --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic && \
  apk -v --purge del py-pip && \
  rm /var/cache/apk/*

ENV AWS_DEFAULT_REGION us-west-2
ENV AWS_DEFAULT_OUTPUT json

COPY ddns53.sh /usr/local/bin/ddns53.sh
RUN chmod +x /usr/local/bin/ddns53.sh

COPY systemd/ddns53.service /etc/systemd/system/ddns53.service
COPY systemd/ddns53.timer /etc/systemd/system/ddns53.timer

RUN systemctl daemon-reload
RUN systemctl enable ddns53.timer
RUN systemctl start ddns53.timer