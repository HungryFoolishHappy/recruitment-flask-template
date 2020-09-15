dialogflow nlp experiment
====

This will emulate
1. A chat server send a message to your server (this server) via webhook,
1. You will send that message to Dialogflow and it will return the intent of the message
1. You will search for a response in the databse and reply it back to the chat server

You will need
- git
- docker
- sending HTTP request to API server with cURL or Postman
- a language and a application server of choice, python and [Flask](https://github.com/pallets/flask) in this case
- a way to expose a local server to public, e.g. [ngrok](https://ngrok.com)
- basic understand of ORM (Object-relational mapping)

Detail steps
1. Pull [this repostory](git@github.com:HungryFoolishHappy/recuitment-flask-template.git)
1. Start the server with docker compose
1. Get your user id and save it in a variable
1. Retrieve the service account from `users/[your user id]/service_account`.
With curl, postman or some other means, and save it in a file (service_account.json)
1. Expose the server to public using ngrok
1. Register the endpoint in `users/[your user id]/webhook` with a PUT request,
the endpoint expect JSON body with the structure `{ "webhook": your web hook here  }`
1. Use `/users/[your user id]/simulate-actions/speaks`
to request the chat server to send you a message
1. Extract the utterence from the message,
and use session client form dialogflow to resolve the intent
1. Return `{ "intent": the intent resolved by dialogflow }` as the response of your webhook
1. Use `/users/[your user id]/simulate-actions/speaks` again but
with `{ "validate": "image_url" }` as the request body
1. This time after getting the intent from dialogflow,
from the database find the snack or drink requested in the message,
then return it as a JSON object


```sh
docker build --tag dialogflow-nlp-experiment .
docker run --rm -v `pwd`:/app -p 5000:5000 dialogflow-nlp-experiment
```
