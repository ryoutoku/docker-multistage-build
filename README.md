# docker-multistage-build

sample for docker multistage build

## architecture image

```mermaid
classDiagram
    builder_core <|-- builder_development
    builder_core <|-- builder_production
    builder_core: copy from host
    builder_development: install module for development
    builder_production:  install module for production

    execution_base  <|-- development
    execution_base  <|-- production
    execution_base 　--> builder_core
    development --> builder_development
    production --> builder_production
    execution_base: create base image
    execution_base: copy from builder_core
    development: copy module from builder_development
    production: copy module from builder_production
```

## check with docker compose

```bash
# show install modules

# production
docker compose run production pip freeze

# output:
# certifi==2022.6.15
# distlib==0.3.6
# filelock==3.8.0
# numpy==1.23.2
# platformdirs==2.5.2
# virtualenv==20.16.4
# virtualenv-clone==0.5.7

# flake8, autopep8 is not containe


# development
docker compose run development pip freeze
# output: omit

```
