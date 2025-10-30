# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a bundle repository for the multicluster global hub operator, part of the Red Hat Advanced Cluster Management (ACM) ecosystem. It packages Kubernetes operator manifests for distribution via Operator Lifecycle Manager (OLM).

## Repository Structure

- `bundle/` - Contains the operator bundle structure:
  - `manifests/` - Kubernetes manifests including ClusterServiceVersion (CSV), CRDs, and service definitions
  - `metadata/` - Bundle metadata including annotations.yaml
  - `tests/` - Scorecard test configuration for operator validation
- `.tekton/` - Tekton CI/CD pipeline definitions for automated builds
- `Containerfile.bundle` - Container build definition for the bundle image
- `konflux-patch.sh` - Script that patches manifests with production image references

## Build Process

### Container Build
```bash
# Build the bundle container image
podman build -f Containerfile.bundle -t multicluster-global-hub-operator-bundle:latest .
```

### Bundle Validation
```bash
# Run operator scorecard tests
operator-sdk scorecard bundle/
```

The build process involves:
1. Copying bundle manifests and metadata into a container
2. Running `konflux-patch.sh` to replace development image references with production registry URLs
3. The script updates the CSV with proper Red Hat registry images and versioning

## Key Components

### ClusterServiceVersion (CSV)
- Main manifest: `bundle/manifests/multicluster-global-hub-operator.clusterserviceversion.yaml`
- Defines operator metadata, permissions, and deployment specifications
- Contains examples for MulticlusterGlobalHub, MulticlusterGlobalHubAgent, and ManagedClusterMigration CRDs

### Custom Resource Definitions (CRDs)
- `operator.open-cluster-management.io_multiclusterglobalhubs.yaml` - Main hub configuration
- `operator.open-cluster-management.io_multiclusterglobalhubagents.yaml` - Agent configuration
- `global-hub.open-cluster-management.io_managedclustermigrations.yaml` - Migration operations

### Image Management
The `konflux-patch.sh` script manages image references for:
- multicluster-global-hub-operator
- multicluster-global-hub-manager
- multicluster-global-hub-agent
- grafana
- postgres-exporter
- postgresql

## CI/CD Pipeline

### Tekton Pipelines
- Push pipeline: `.tekton/multicluster-global-hub-operator-bundle-globalhub-1-6-push.yaml`
- Builds and publishes container images to `quay.io/redhat-user-workloads/`
- Uses the `konflux-build-catalog` pipeline templates

### GitHub Actions
- `.github/workflows/labels.yml` - Automatically labels PRs from Konflux bot

## Branch Strategy
- Main development branch: `release-1.6`
- Version scheme follows semantic versioning aligned with the 1.6 release track