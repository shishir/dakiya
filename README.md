# Dakiya

**TODO: Add description**

## Installation


## Usage

### PART 1/ PART 2 - CLI
```
  > ./dakiya --message="{\"to\": \"user@example.com\", \"subject\": \"Example Email\", \"body\": \"<html><body><h1>Hello World</h1></body></html>\"}"

  OR

  > ./dakiya --message="{\"to\": \"user@example.com\", \"subject\": \"Example Email\", \"template\": {\"name\":\"password-reset\", \"message\":\"Password reset\"} }"
```

## Assumptions/Constraints

- **Part 1**:
 - validations are not exhaustive. It is demonstration how validation errors can be handled.

- **Part 2**
  - validations do not check for the validity of template variables or if the template exists. If implemented
  will follow the same pattern as other validation.



