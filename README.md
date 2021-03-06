# Dakiya

  Enables sending emails via CLI or a Rest end-point. Its uses Mailgun in the background.

## Installation/Running
```
  > export MAILGUN_API_KEY=<KEY>
  > export MAILGUN_DOMAIN_NAME=<KEY>
  > cd dakiya

  # For building CLI executable
  > mix deps.get
  > mix escript.build

  # For Running HTTP Server
  > mix run --no-halt

  # For runing tests
  > mix test
```

## Usage


#### CLI
```
  # With body
  > ./dakiya --message="{\"to\": \"user@example.com\", \"subject\": \"Example Email\", \"body\": \"<html><body><h1>Hello World</h1></body></html>\"}"

  OR
  # With template
  > ./dakiya --message="{\"to\": \"user@example.com\", \"subject\": \"Example Email\", \"template\": {\"name\":\"password-reset\", \"message\":\"Password reset\"} }"
```


#### Web
```
  curl -d"{\"to\": \"shishir.das@gmail.com\", \"subject\": \"foo bar baz\", \"body\": \"<html><body><h1>Hello World</h1></body></html>\"}" -H"Content-Type: application/json" localhost:8080/create
```

## Assumptions/Constraints/Decisions

- **Part 1**:
 - validations are not exhaustive. It is a demonstration of how validation errors can be handled. Though, the app assumes all other informations passed is valid.
 - help option not implemented. Time constraint.

- **Part 2**
  - validations do not check for the validity of template variables or if the template exists. If implemented
  will follow the same pattern as other validation.
  - Used **eex** for **templating**. It is part of elixir and sufficient for our use case.

- **Part 3**
  - **Cowboy as HttpServer with Plug **. Plug over phoenix framework because its light weight and fast and is sufficient for the use case.
  - No authentication implemented. Time constraint. In full blown system, we might want to provide ability for the user to generate api-token for using REST Api
  - Endpoints supported ```/create```. This will send the email via Mailgun.

- **Part 4**
  -





