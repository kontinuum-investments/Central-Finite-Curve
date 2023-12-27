# Description
This repository serves as the primary repository for all essential artifacts required by the systems operating within the Central Finite Curve.

# Installation
1. Create a virtual machine _(preferably with at least 2GB of memory)_
2. Create a Cloudflare tunnel
4. Run the following command:

```bash
bash <(curl -s "https://raw.githubusercontent.com/kontinuum-investments/Central-Finite-Curve/production/citadel/scripts/initialize.sh") "{{$CLOUDFLARE_TUNNEL_TOKEN}}"
```

# Microservices
| Service  |                  Description                  | Container Port | Host Port | Production Environment URL  |       Test Environment URL       |
|:--------:|:---------------------------------------------:|:--------------:|:---------:|:---------------------------:|:--------------------------------:|
| Website  |       Main website of the organisation        |     `5000`     |  `1001`   |   https://www.kih.com.sg    |              _N/A_               |
| Vita API | Back-end of personal life automation service  |     `8000`     |  `1002`   | https://vita-api.kih.com.sg | https://vita-api-test.kih.com.sg |
|   Vita   | Front-end of personal life automation service |     `5000`     |  `1003`   |   https://vita.kih.com.sg   |   https://vita-test.kih.com.sg   |

## To deploy a new Microservice
1. SSH into the Citadel
2. Run the following command:

```bash
source <(curl -s "https://raw.githubusercontent.com/kontinuum-investments/Central-Finite-Curve/production/citadel/scripts/library.sh") && 
  deploy_container "$DOCKERHUB_USERNAME/$IMAGE_NAME:$TAG" "$CONTAINER_PORT" "$HOST_PORT" "$ENV_VARS"
```

Where the environmental variables (`$ENV_VARS`) are key-value pairs and are comma-separated _(e.g. `ENVIRONMENT=Production,APP_NAME=Vita`)_


## Required Organisational Secrets
- `CITADEL_SSH_PRIVATE_KEY`

## Required Organisational Variables
- `CITADEL_USERNAME`
- `CITADEL_HOST_NAME`