#!/usr/bin/env python3
# Usage: $0 [gh-user] [gh-repo] [gh-token]

import os
import requests
import subprocess
import sys


def get_branch(rev):
    try:
        revparse = ["git", "rev-parse", "--abbrev-ref", rev]
        print("".join(revparse))
        v = subprocess.check_output(revparse, stderr=open(os.devnull, "wb"))

        print(v.decode("utf-8").strip(" \r\n").split("/")[-1])
    except subprocess.CalledProcessError:
        pass


remote = os.environ.get("GIT_REMOTE", default="origin")
get_branch(f"{remote}/HEAD")

print(f"received {len(sys.argv)} arguments")
if len(sys.argv) < 4:
    print(f"error: {sys.argv[0]} unable to determine default branch", file=sys.stderr)
    get_branch("HEAD")
    exit(1)

url = f"https://api.github.com/repos/{sys.argv[1]}/{sys.argv[2]}"
headers = {
    "Authorization": f"bearer {sys.argv[3]}",
    "Accept": "application/vnd.github.v3+json",
}
response = requests.get(url, headers=headers)
response.raise_for_status()
result = response.json()

print(result["default_branch"])
