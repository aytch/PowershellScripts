# curl -F 'access_token=<token>' \
#  -F 'apikey=<key>' \
#  -F "payload=<json_payload>" \
#  https://some.endpoint.com/api

$postparams = @{
  'access_token' = "<token>";
  'apikey' = "<key>";
  'payload' = "<json_payload>"
}

Invoke-WebRequest -uri 'https://some.endpoint.com/api' -Method POST -body $postparams
