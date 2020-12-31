#!/bin/bash

ACCEPT='application/json'
CONTENT_TYPE='application/json'
UA='Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1'
ORIGIN='https://m.bbs.mihoyo.com'
REFER='https://m.bbs.mihoyo.com/'
ENCODING='gzip, deflate, br'


COOKIE='myCookie'

APP_VERSION='2.3.0'
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
  local salt="h8w582wxwgqvahcdkpvdhbh2w9casgfl"
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

appWebviewPost() {
  local URL=$1
  local BODY=$2
  local devID=$(uuidgen)
  local DS=$(genDS)

  if [ -z "$BODY" ]; then
    curl -X POST "$URL" -H "DS: $DS" -H "x-rpc-client_type: $CLIENT_TYPE" -H "x-rpc-app_version: $APP_VERSION" -H "x-rpc-device_id: $devID" -H "X-Requested-With: com.mihoyo.hyperion" -H "Accept: $ACCEPT" -H "Accept-Encoding: $ENCODING" -H "User-Agent: $UA" -H "Referer: $REFER" -H "Origin: $ORIGIN" -b "./cookies/$COOKIE" -s --compressed
  else
    curl "$URL" -H "DS: $DS" -H "x-rpc-client_type: $CLIENT_TYPE" -H "x-rpc-app_version: $APP_VERSION" -H "x-rpc-device_id: $devID" -H "X-Requested-With: com.mihoyo.hyperion" -H "Accept: $ACCEPT" -H "Accept-Encoding: $ENCODING" -H "User-Agent: $UA" -H "Referer: $REFER" -H "Origin: $ORIGIN" -b "./cookies/$COOKIE" -s --compressed -d "$BODY"
  fi
}
