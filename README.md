This repository houses as the headquarters of the Central Finite Curve housing all the necessities to function.

# Architectural Diagram
<img alt="Central Finite Curve's Architectural Diagram" src="https://raw.githubusercontent.com/kontinuum-investments/Central-Finite-Curve/production/media/Architectural%20Diagram.svg">

# DNS Records
|  Type   |      Name       |        Description         | Cloudflare Proxied? |
|:-------:|:---------------:|:--------------------------:|:-------------------:|
| `CNAME` |  `@` _(root)_   |    Organisation Website    |         ✔️          |
| `CNAME` |      `www`      |    Organisation Website    |         ✔️          |
| `CNAME` |   `vita-api`    |          Vita API          |         ✔️          |
| `CNAME` | `vita-api-test` |     Vita API _(Test)_      |         ✔️          |
| `CNAME` |     `vita`      |            Vita            |         ✔️          |
| `CNAME` |   `vita-test`   |       Vita _(Test)_        |         ✔️          |
|   `A`   |    `citadel`    |     Citadel Host Name      |         ❌️          |
|   `A`   | `citadel-test`  | Citadel _(Test)_ Host Name |         ❌️          |