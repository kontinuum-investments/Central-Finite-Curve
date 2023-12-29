# Description
This repository serves as the primary repository for all essential artifacts required by the systems operating within the Central Finite Curve.

# How to Deploy
1. Create a MongoDB compatible database
2. Create a virtual machine ([Azure Guide](#how-to-deploy-in-azure))
   1. Assign at least 2GB or memory _(Docker's recommended requirement)_
   2. Assign a static public IP to the virtual machine
2. Set the `citadel` or `citadel-test` A record for the IP address in the DNS records
3. Create a Cloudflare tunnel
4. Run the following command:

```bash
bash <(curl -s "https://raw.githubusercontent.com/kontinuum-investments/Central-Finite-Curve/production/citadel/scripts/initialize.sh") "$CLOUDFLARE_TUNNEL_TOKEN" "$GITHUB_ACCESS_TOKEN"
```

## How to deploy in Azure
<details><summary></summary>
   <ol>
   <li>Create a resource group</li>
   <li>
      Create an <code>Azure Cosmos DB for MongoDB</code> database
         <ol>
            <li>Type of resource: <code>Request unit (RU) database account</code></li>
            <li>Capacity Mode: <code>Serverless</code></li>
         </ol>
   </li>
   <br/>

   <li>
      Create a Virtual Machine with:
      <ol>
         <li><code>Standard_B1ms</code> size (or higher specifications)</li>
         <li>Username: <code>kavindu</code></li>
         <li>SSH public key source: <code>Use existing public key</code></li>
         <li>
            <details>
               <summary>
                  SSH public key [<code>Production</code>]
               </summary>
                  <code>ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbg7PTGQx0I9MFCmwtaZ9Q95wkfi7SVnhVDo+dQZqgbwMjbZrsC/cq6elLUD8vr2Pf8WSQJElXssenPyz4P3IpMgNBW30rOfvBtm/EXTPU0U+autNl6t3aWc3Pu0EhgtieAsDClUq1PxEo8RqMPZrwfctuIwVZUNOHRN3UnOwPrbKE6mHRJFKXWAqEprQssMqFJQP0Mvr0SxvMf9QSjUbI2kJvWg+1kQO+VkI1mXDfkxslKOpXId9OBEenzqewwyijE0kPlm0xZ2OeG9J4mJBe5CBWt9/h0CJoOy0jUQiFM5rk7ejD7PbOut8qDwSjL+uH3zMKKC00aBt0xYWiqBJnZmN0BfhHC7TNjpQNZZ065zlIpQ6CMGC1qV0Jzo7WRctNPpGr+vJAQ86d+PMPSUeX1k/SfRoV+j3lbkSG6t4pONS1rcLzleGHc3B34zuCqgQMlhXlSGbFVUGI1ugKl2Q9onn5ZjgeLWLVu+eiIM1uQH2ZhRlaPlPXVJ9+Apvcbiv0BAB6SXu3ZgUo7B1EYtdK2eDJYOBSgFn4XozAlRSA6kKP1k+Ms3yLDRv+gIGWnpTDo7hy4QgSTL4VO+jjAX+FXwTF/XxmyKte4KaCtxq0HpTG1oLm9YDg5eP64ihvJOWsqHght7RkW5P7aCipelrXhgjnGOYvs73kIjcy6i75IQ==</code>
            </details>
            <details>
               <summary>
                  SSH public key [<code>Test</code>]
               </summary>
                  <code>ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbg7PTGQx0I9MFCmwtaZ9Q95wkfi7SVnhVDo+dQZqgbwMjbZrsC/cq6elLUD8vr2Pf8WSQJElXssenPyz4P3IpMgNBW30rOfvBtm/EXTPU0U+autNl6t3aWc3Pu0EhgtieAsDClUq1PxEo8RqMPZrwfctuIwVZUNOHRN3UnOwPrbKE6mHRJFKXWAqEprQssMqFJQP0Mvr0SxvMf9QSjUbI2kJvWg+1kQO+VkI1mXDfkxslKOpXId9OBEenzqewwyijE0kPlm0xZ2OeG9J4mJBe5CBWt9/h0CJoOy0jUQiFM5rk7ejD7PbOut8qDwSjL+uH3zMKKC00aBt0xYWiqBJnZmN0BfhHC7TNjpQNZZ065zlIpQ6CMGC1qV0Jzo7WRctNPpGr+vJAQ86d+PMPSUeX1k/SfRoV+j3lbkSG6t4pONS1rcLzleGHc3B34zuCqgQMlhXlSGbFVUGI1ugKl2Q9onn5ZjgeLWLVu+eiIM1uQH2ZhRlaPlPXVJ9+Apvcbiv0BAB6SXu3ZgUo7B1EYtdK2eDJYOBSgFn4XozAlRSA6kKP1k+Ms3yLDRv+gIGWnpTDo7hy4QgSTL4VO+jjAX+FXwTF/XxmyKte4KaCtxq0HpTG1oLm9YDg5eP64ihvJOWsqHght7RkW5P7aCipelrXhgjnGOYvs73kIjcy6i75IQ==</code>
            </details>
         </li>
      <li>A static public IP (in the <code>Networking</code> section)</li>
      <li>Tick <code>Delete public IP and NIC when VM is deleted</code> (in the <code>Networking</code> section)</li>
      </ol>
   </li>
   </ol>
</details>

# Microservice Descriptions
| Service  |                  Description                  | Container Port | Host Port | Production Environment URL  |       Test Environment URL       |
|:--------:|:---------------------------------------------:|:--------------:|:---------:|:---------------------------:|:--------------------------------:|
| Website  |       Main website of the organisation        |     `5000`     |  `1001`   |   https://www.kih.com.sg    |              _N/A_               |
| Vita API | Back-end of personal life automation service  |     `8000`     |  `1002`   | https://vita-api.kih.com.sg | https://vita-api-test.kih.com.sg |
|   Vita   | Front-end of personal life automation service |     `5000`     |  `1003`   |   https://vita.kih.com.sg   |   https://vita-test.kih.com.sg   |

# How to deploy a new Microservice
1. SSH into the Citadel
2. Run the following command:

```bash
source <(curl -s "https://raw.githubusercontent.com/kontinuum-investments/Central-Finite-Curve/production/citadel/scripts/library.sh") && 
  deploy_container "$DOCKERHUB_USERNAME/$IMAGE_NAME:$TAG" "$CONTAINER_PORT" "$HOST_PORT" "$ENV_VARS"
```
Where the environmental variables (`$ENV_VARS`) are key-value pairs and are comma-separated _(e.g. `ENVIRONMENT=Production,APP_NAME=Vita`)_

# Settings for needed for GitHub CI/CD
## Required Repository Variables
- `CONTAINER_PORT`
- `HOST_PORT`

## Required Organisational Secrets
- `CITADEL_SSH_PRIVATE_KEY`

## Required Organisational Variables
- `CITADEL_USERNAME`
- `CITADEL_HOST_NAME`