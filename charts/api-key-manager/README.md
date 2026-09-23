# API Key Manager Helm chart

Deploys all the necessary components for a working API Key Manager instance:

- API Key Manager back-end
- GUI
- Database (official `postgres` image)
- Reverse-proxy (nginx)

The proxy serves the GUI at `/` and the API at `/api/` on a single NodePort (default `30108`). Services inside the cluster can call the API service directly. Database migrations run in an init container before the API starts.

## Usage

```bash
helm repo add jtekt https://jtekt.github.io/helm-repository/
helm install api-key-manager jtekt/api-key-manager \
  --set oidc.jwksUri=https://keycloak.example.com/realms/my-realm/protocol/openid-connect/certs \
  --set oidc.authority=https://keycloak.example.com/realms/my-realm \
  --set oidc.clientId=api-key-manager
```

Without `oidc.jwksUri`, the API trusts the `X-User-ID` header and any caller can act as any user. Only use that for development.

## Values

| Key | Description |
|---|---|
| `image` / `gui.image` | API and GUI images |
| `oidc.jwksUri`, `oidc.issuer`, `oidc.userClaim` | Bearer token verification for the API |
| `oidc.authority`, `oidc.clientId` | OIDC login for the GUI |
| `api.keyPepper` | Secret appended to keys before hashing. Changing it invalidates all existing keys |
| `api.env` | Extra API environment variables (e.g. `ARGON2_MEMORY_COST`) |
| `gui.appsUrl` | App launcher link shown in the GUI |
| `postgresql.enabled` | Deploy the bundled PostgreSQL. If disabled, set `postgresql.connectionString` |
| `postgresql.image.repository`, `postgresql.image.tag` | Image of the bundled PostgreSQL (default `postgres:17`) |
| `postgresql.auth.*` | Credentials of the bundled PostgreSQL. Change the password before deploying to production |
| `postgresql.persistence.size` | Size of the PostgreSQL volume |
| `proxy.service.type`, `proxy.service.nodePort` | Service exposing the proxy (default NodePort `30108`) |
