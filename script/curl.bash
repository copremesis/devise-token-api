#!/bin/bash
echo 'login'
export port=5000
export host=http://localhost:$port
export sleep=0

#RESTFUL API using DEVISE

#sign in and set the token

echo 'POST' $host/api/v1/users/sign_in
time export token=$(
curl -s -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -X POST $host/api/v1/users/sign_in  \
  -d '{"user": {"email" : "test@somewhere.net", "password":"password"}}' \
  | python -mjson.tool | grep token | cut -d: -f2 | sed 's/ *"//g' \

  )

echo $token

echo 'GET' $host/api/v1/debug
time curl -s -H "Accept: application/json"  \
        -H "Content-Type: application/json"  \
        -H "x-auth-token: $token" \
        -X GET "$host/api/v1/debug" \
        | python -mjson.tool


echo 'POST' $host/api/v1/debug
time curl -s -H "Accept: application/json" -H "Content-Type: application/json" -H "x-auth-token: $token" -X POST $host/api/v1/debug -d '{}' | python -mjson.tool

time curl -s -H "Accept: application/json"  \
  -H "Content-Type: application/json"  \
  -H "x-auth-token: $token" \
  -X PUT $host/api/v1/debug \
  -d '{"blackout_dates":["Jan 3","Jan 4","Jan 5","Jan 6","Jan 7","Jan 8","Jan 9","Jan 10","Jan 11","Jan 12","Jan 13","Jan 14","Jan 15","Jan 16","Jan 17","Jan 18","Jan 19","Jan 20","Jan 21","Jan 22","Jan 23","Jan 24","Jan 25","Jan 26","Jan 27","Jan 28","Jan 29","Jan 30","Jan 31"]}' \
  | python -mjson.tool


echo 'DELETE' $host/api/v1/debug
time curl -s -H "Accept: application/json"  \
        -H "Content-Type: application/json"  \
        -H "x-auth-token: $token" \
        -X DELETE "$host/api/v1/debug" \
        | python -mjson.tool

#will request that current token be reset with a new one
echo 'logout' && sleep $sleep
echo 'DELETE' $host/api/v1/users/sign_out
time curl -s -H "Accept: application/json"  \
        -H "Content-Type: application/json"  \
        -H "x-auth-token: $token" \
        -X DELETE $host/api/v1/users/sign_out  \
        | python -mjson.tool


