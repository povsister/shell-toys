#!/bin/bash
BASE=$(dirname $0)

cd "$BASE"
source ./common.sh
verifyCookie

REFERER='https://webstatic.mihoyo.com/bbs/event/signin-ys/index.html?bbs_auth_required=true&act_id=e202009291139501&utm_source=bbs&utm_medium=mys&utm_campaign=icon'
ORIGIN='https://webstatic.mihoyo.com'

gids="YS"

for i in ${gids}; do
  retry=0
  while true; do

    resp=$(httpPost "https://api-takumi.mihoyo.com/event/bbs_sign_reward/sign")
    retcode=$(echo -n $resp|jq -r '.retcode')
    if [ "$retcode" == "0" -o "$retcode" == "1008" -o "$retcode" == "2001" ]; then
      echo "SignIn OK for $i. $resp"
      break
    fi

    if [ $retry -ge 5 ]; then
      echo "Retry limit. break"
    fi
    retry=$((retry+1))
    echo "SignIn Failed for $i. retry $retry. $resp"
    sleep 3

  done
done


