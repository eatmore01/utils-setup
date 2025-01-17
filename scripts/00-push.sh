#!/usr/bin/env bash

MESSAGE="$1"
BRANCH="$2"
DATE=$(date)

if [ -n "$BRANCH" ]; then
	PUSH_BRANCH="$BRANCH"
else
	PUSH_BRANCH="main"
fi

if [ -n "$MESSAGE" ]; then
	git add .
	git commit -m "$MESSAGE"
	git push origin "$PUSH_BRANCH"
	echo "pushing complete succefuly"
	exit 0
else
  	git add .
  	git commit -m "commited without message at date: $DATE"
	git push origin "$PUSH_BRANCH"
  	echo "pushing complete succefuly"
  	exit 0
fi