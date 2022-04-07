#!/usr/local/bin/python
import email
import json
import os
import requests
import sys
from dotenv import load_dotenv

load_dotenv()

def main():
    msg = email.parser.Parser().parse(sys.stdin)
    payload = {
        "channel": "#" + sys.argv[1],
        "text": msg.get("Subject"),
        "blocks": [
            {
                "type": "header",
                "text": {
                    "type": "plain_text",
                    "text": msg.get("Subject")
                    }
                },
            {
                "type": "section",
                "fields": [
                    {
                        "type": "mrkdwn",
                        "text": "*From:*\n" + msg.get("From")
                        }
                    ]
                },
            {
                "type": "section",
                "text": {
                    "type": "mrkdwn",
                    "text": msg.get_payload()
                    }
                }
            ]
        }

    url = os.getenv("WEBHOOK_URL")
    headers = {"Content-Type": "application/json"}
    response = requests.post(url=url, data=json.dumps(payload), headers=headers)
    if response.status_code != requests.codes.ok:
        sys.exit(1)

    sys.exit(0)

if __name__ == "__main__":
    main()
