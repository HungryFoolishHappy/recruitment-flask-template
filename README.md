Dialogflow NLP experiment
====

This experiment emulate
----
1. A chat server send a message to this server via webhook,
1. This server should send that message to [Dialogflow](https://cloud.google.com/dialogflow/docs) and it will return the intent of the message
1. This server should search for a response in the databse and reply it back to the chat server

You will need
----
- git
- docker
- sending HTTP request to API server with cURL or Postman
- a language and a application server of choice, python and [Flask](https://github.com/pallets/flask) in this case
- a way to expose a local server to public, e.g. [ngrok](https://ngrok.com)
- basic understanding of ORM (Object-relational mapping), in this case [SQLAlchemy](https://www.sqlalchemy.org). Only having general knowledge of ORM will suffice, we will only use the most basic feature in this experiment
- basic understanding of server to server communication, [webhook](https://en.wikipedia.org/wiki/Webhook) to be specific.

Detail steps
----
1. Pull [this repostory](git@github.com:HungryFoolishHappy/recuitment-flask-template.git)
1. Start the server with docker (see commands [below](#useful-commands))
1. Get your user id and save it in a variable
1. Retrieve the service account from `users/[your user id]/service_account`.
With curl, postman or some other means, and save it in a file (e.g. service_account.json)
1. Expose the server to public using ngrok
1. Register the your webhook endpoint
under the chat server's `users/[your user id]/webhook` with a PUT request,
the endpoint expect JSON body with the structure `{ "webhook": your web hook here  }`
1. Use `/users/[your user id]/simulate-actions/speaks`
to request the chat server to send you a message
1. Extract the utterence from the message,
and use [SessionsClient](https://googleapis.dev/python/dialogflow/latest/gapic/v2/api.html#dialogflow_v2.SessionsClient) form Dialogflow to resolve the intent
1. Return `{ "intent": the name of the intent resolved by dialogflow }` as the response of your webhook, we will treat the value in `queryResult.action` as the intent name
1. Call `/users/[your user id]/simulate-actions/speaks` again but
with `{ "should_validate_image_url": true }` as the request body. This time after getting the intent from dialogflow,
 find the requested snack or drink from the database and return it as a JSON object

Files included in this repo
----
- this README
- `main.py`, the entry point of the server
- `Dockerfile`, for creating the container to run the server
- `pyproject.toml` and `poetry.lock`, used by poetry for installing dependencies, which is alredy handled in the `Dockerfile`
- `models.py`, defining the SQLAlchemy models
- `databse.py`, for setting up the database connection, and configuring the ORM
- `database.sqlite`, storing the response you will need to send back to the chat server. Used by the ORM


Useful commands
----
```sh
# build the image
docker build --tag dialogflow-nlp-experiment .
# run the container (this image was running flask in development mode, it will auto-reload upon file change, manually restarting the container is not necessary)
docker run --rm -v `pwd`:/app -p 5000:5000 dialogflow-nlp-experiment
```
