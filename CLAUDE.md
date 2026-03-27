# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Helm chart repository for JTEKT Corporation, hosting charts for Kubernetes deployments. Charts are published to two places:
- **GitHub Pages** (via `helm/chart-releaser-action`) on push to `master`
- **Internal ChartMuseum** at `https://chartmuseum.jtektrnd.net` (via `release.sh` used in GitLab CI)

## Common Commands

```bash
# Package a single chart
helm package charts/<chart-name>

# Lint a chart
helm lint charts/<chart-name>

# Update chart dependencies
helm dependency update charts/<chart-name>

# Template a chart (dry-run to inspect output)
helm template <release-name> charts/<chart-name> -f custom-values.yaml

# Validate against a cluster
helm install --dry-run <release-name> charts/<chart-name>

# Release all charts to ChartMuseum (used by GitLab CI)
bash release.sh
```

## Chart Architecture

### Standard Structure

Each chart follows this layout:
```
charts/<chart-name>/
├── Chart.yaml
├── values.yaml
├── Chart.lock          # Present when chart has dependencies
├── templates/
│   ├── _helpers.tpl    # Name/label helpers
│   ├── NOTES.txt
│   └── <component>/    # Subdirectories per component
│       ├── deployment.yml
│       └── service.yml
└── charts/             # Vendored dependency charts
```

### Multi-Component Pattern

Most charts follow a **GUI + API + Proxy** pattern:
- **GUI**: Frontend deployment served via nginx or similar
- **API**: Backend service
- **Proxy**: Kong or nginx reverse proxy, configured via a ConfigMap (`*-cm.yml`)

Simpler charts (annotation tools) use only **GUI + Proxy**.

### Image Registry

All JTEKT application images are pulled from `public.ecr.aws/jtekt-corporation/`. The `ecr-pullsecret-renewer` chart exists specifically to maintain ECR pull secrets across namespaces (runs as an hourly CronJob with ClusterRole permissions).

### Dependencies

External Helm repos used as dependencies:
| Alias | URL |
|---|---|
| `bitnami` | https://charts.bitnami.com/bitnami |
| `moreillon` | https://maximemoreillon.github.io/helm-repository/ |
| `kong` | https://charts.konghq.com |
| `neo4j` / `neo4j-helm-charts` | https://helm.neo4j.com/neo4j |

Add these locally before working with charts that have dependencies:
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add moreillon https://maximemoreillon.github.io/helm-repository/
helm repo add kong https://charts.konghq.com
helm repo add neo4j https://helm.neo4j.com/neo4j
helm repo add neo4j-helm-charts https://neo4j.github.io/helm-charts/
```

### Naming Convention in Templates

`_helpers.tpl` defines a `<chart-name>.prefix` template that typically resolves to `<release>-<chart>` (truncated to 63 chars for DNS compatibility). This prefix is used for all resource names. The newer `ecr-pullsecret-renewer` chart uses the standard Helm scaffolding pattern (`fullname`, `labels`, `selectorLabels`).

### Database Handling

Charts with database dependencies expose an "external connection string" option in `values.yaml`, allowing the bundled database subchart to be disabled and an external instance used instead. Example pattern in `image-storage-service`:
```yaml
mongodb:
  enabled: true
  # If disabled, set connectionString to external MongoDB
```

### Services & Ports

Charts expose services via **NodePort** with specific port assignments defined in `values.yaml`. Default ports are in the `30000–32767` NodePort range.

## CI/CD

- **GitHub Actions** (`.github/workflows/release.yml`): Triggers on push to `master`, runs `chart-releaser-action` to publish to GitHub Releases/Pages.
- **GitLab CI** (`.gitlab-ci.yml`): Triggers on `master`, runs `bash release.sh` to push packaged charts to the internal ChartMuseum instance.

Both pipelines run on the same commit — GitHub publishes to the public Artifact Hub–listed repo, GitLab publishes to the internal registry.
