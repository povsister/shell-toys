#!/bin/bash

ACCEPT='application/json'
CONTENT_TYPE='application/json'
UA='Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1'
ORIGIN='https://m.bbs.mihoyo.com'
REFER='https://m.bbs.mihoyo.com/'
ENCODING='gzip, deflate, br'


COOKIE='myCookie'

APP_VERSION='2.1.0'
CLIENT_TYPE='5'

verifyCookie() {
  if [ ! -f "./cookies/$COOKIE" ]; then
    echo "./cookies/$COOKIE not exist!"
    exit 1
  fi
}

genDS() {
  local UUID=$(uuidgen)
  local r=${UUID:0:6}
  local now=$(date +%s)
  local salt=`echo -n $APP_VERSION | md5sum | awk '{print $1}'`
  local DS=`echo -n "salt=$salt&t=$now&r=$r" | md5sum | awk '{print $1}'`
  echo "$now,$r,$DS"
}

httpGet() {
  local URL=$1
  local DS=$(genDS)
  curl "$URL" -H "x-rpc-app_version: $APP_VERSION" -H "x-rpc-client_type: $CLIENT_TYPE" -H "DS: $DS" -H "Accept: $ACCEPT" -H "Accept-Encoding: $ENCODING" -H "Content-Type: $CONTENT_TYPE" -H "User-Agent: $UA" -H "Referer: $REFER" -H "Origin: $ORIGIN" -b "./cookies/$COOKIE" -s --compressed
}

httpPost() {
  local URL=$1
  local DS=$(genDS)
  local BODY=$2

  if [ -n "$BODY" ]; then
    curl "$URL" -H "x-rpc-app_version: $APP_VERSION" -H "x-rpc-client_type: $CLIENT_TYPE" -H "DS: $DS" -H "Accept: $ACCEPT" -H "Accept-Encoding: $ENCODING" -H "Content-Type: $CONTENT_TYPE" -H "User-Agent: $UA" -H "Referer: $REFER" -H "Origin: $ORIGIN" -b "./cookies/$COOKIE" -s --compressed -d "$BODY"
  else
    curl -X POST "$URL" -H "x-rpc-app_version: $APP_VERSION" -H "x-rpc-client_type: $CLIENT_TYPE" -H "DS: $DS" -H "Accept: $ACCEPT" -H "Accept-Encoding: $ENCODING" -H "Content-Type: $CONTENT_TYPE" -H "User-Agent: $UA" -H "Referer: $REFER" -H "Origin: $ORIGIN" -b "./cookies/$COOKIE" -s --compressed
  fi
}
