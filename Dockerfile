FROM python:slim

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    postfix \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN pip install -U pip && pip install --no-cache-dir\
  requests \
  python-dotenv

EXPOSE 25 465 587 2525 

ARG USERID=1000
RUN useradd -u $USERID -m slack
WORKDIR /home/slack

COPY rootfs/etc/postfix/* /etc/postfix/
RUN postmap /etc/postfix/transport

COPY slack.py entrypoint.sh ./
RUN chmod +x slack.py entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
