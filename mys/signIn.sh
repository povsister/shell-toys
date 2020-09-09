#!/bin/bash
BASE=$(dirname $0)

cd "$BASE"
source ./common.sh
verifyCookie

gids="1 2 3 4 5"

for i in ${gids}; do
  retry=0
  while true; do

    resp=$(httpPost "https://api-takumi.mihoyo.com/apihub/api/signIn" "{\"gids\":\"$i\"}")
    retcode=$(echo -n $resp|jq -r '.retcode')
    if [ "$retcode" == "0" -o "$retcode" == "1008" -o "$retcode" == "2001" ]; then
      echo "SignIn OK for forum $i. $resp"
      break
    fi

    if [ $retry -ge 5 ]; then
      echo "Retry limit. break"
    fi
    retry=$((retry+1))
    echo "SignIn Failed for forum $i. retry $retry. $resp"
    sleep 3

  done
done


