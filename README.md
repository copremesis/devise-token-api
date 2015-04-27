#devise token based AUTH

Do the following

```
bundle 
git clone git@bitbucket.org:everfest/devise-token-api.git #https://azabua@bitbucket.org/everfest/devise-token-api.git if you do not have a key
cd devise-token-api
rake db:setup #should build db & run seeds
rails s --port 5000 #start the server
# on a seperate shell terminal  ... fire:


curl -s -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -X POST http://localhost:5000/api/v1/users/sign_in  \
  -d '{"user": {"email" : "test@somewhere.net", "password":"password"}}' \
  | python -mjson.tool | grep token | cut -d: -f2 | sed 's/ *"//g' 


```

You should see an _auth_ token i.e.  **B1gTKy-swe_FjGLkMkay** 
which is some randomly generated base64 string

###Thu Apr 23 23:19:45 CDT 2015


The exercise above is to establish the basis of token baed authentication ... a username & password successfully 
returns the _token_ ... now what can we do now that we have access?

To begin facilitating the need to connect IOS to a RESTful API ... I've built some _basic_ examples that 
go over the four RESTful HTTP methods:
  * GET
  * PUT
  * POST
  * DELETE

inside the _script_ folder is a collection of each method running after a successful login

```
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

```

to test you should have this rails repo cloned and setup or we can have this set via DNS or AWS
check with Jake or Steven

Also note that these are the most basic controller to enable a bridge between two applications: Mobile & Rails API

Since we are currently building the API based on existing user data and SQL tables from legacy app this initial step
demonstrates the ability to establish communication through the two parties.

from the console and the _root_ of the rails source tree if you execute the following:

```
/script/curl.bash
```

The output should reflect this output 

```
login
POST http://localhost:5000/api/v1/users/sign_in
B1gTKy-swe_FjGLkMkay
GET http://localhost:5000/api/v1/debug
{
    "success": true
}
POST http://localhost:5000/api/v1/debug
{
    "success": true
}
{
    "success": true
}
DELETE http://localhost:5000/api/v1/debug
{
    "success": true
}
logout
DELETE http://localhost:5000/api/v1/users/sign_out
{}

```

For each of these _api endpoints_ you'll need to construct a way of 
sending these type of transactions from IOS.








