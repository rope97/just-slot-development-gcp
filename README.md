
## Overview

This repository contains a setup for a sample protoype gaming application.

The project demonstrates:

* Infrastructure as Code with Terraform
* GitLab CI/CD pipelines
* Multi-environment deployments
* Kubernetes deployments on Google Kubernetes Engine (GKE)
* Docker image build and push to Google Artifact Registry
* Static frontend hosting on Google Cloud Storage
* Environment separation for development, staging, and production

---

# Architecture

## Environments

| Environment | Branch    | Backend URL                           | Frontend Bucket         |
| ----------- | --------- | ------------------------------------- | ----------------------- |
| Development | `dev`     | https://api-dev-justslots.duckdns.org | `just-slots-fe-dev`     |
| Staging     | `staging` | https://api-staging-slots.duckdns.org | `just-slots-fe-staging` |
| Production  | `main`    | https://api-slots.duckdns.org         | `just-slots-fe-prod`    |

---

# Live Endpoints

## Backend APIs

### Development

https://api-dev-justslots.duckdns.org/

### Staging

https://api-staging-slots.duckdns.org/

### Production

https://api-slots.duckdns.org/

---

## Frontend

Static frontend deployment:

https://storage.googleapis.com/just-slots-fe/index.html

---

# Infrastructure Stack

## Cloud Provider

* Google Cloud Platform (GCP)

## Main Components

* Google Kubernetes Engine (GKE)
* Google Artifact Registry
* Google Cloud Storage
* Kubernetes Deployments
* Kubernetes Services
* Kubernetes Ingress
* Managed TLS Certificates
* GitLab CI/CD
* Docker Buildx

---

# Repository Structure

```text
.
├── apps/
│   ├── game-backend/
│   ├── game-client/
│   └── game-shared/
│
├── ci/
│   ├── backend.gitlab-ci.yml
│   ├── client.gitlab-ci.yml
│   ├── terraform.gitlab-ci.yml
│   └── shared-lib.gitlab-ci.yml
│
├── terraform/
│   ├── environments/
│   │   ├── dev/
│   │   ├── staging/
│   │   └── production/
│   │
│   └── modules/
│       ├── backend-workload/
│       ├── registry/
│       └── static-site/
│
└── .gitlab-ci.yml
```

---

# CI/CD Pipeline

## Terraform Pipeline

Terraform stages:

* terraform fmt
* terraform validate
* terraform plan
* terraform apply

### Features

* Automatic formatting validation
* Merge Request plan generation
* Plan artifact storage
* Manual apply protection
* Environment-aware Terraform execution

---

## Backend Pipeline

### Build

* Docker image build using Docker Buildx
* AMD64-compatible image builds (`linux/amd64`)
* Push to Artifact Registry
* Environment-based image tagging

### Deploy

* Kubernetes rolling deployment
* Environment-specific deployment selection
* Rollout validation
* Smoke testing using `/health`

---

## Frontend Pipeline

### Build

* Node.js application build
* Environment-specific API URL injection

### Deploy

* Upload static files to GCS bucket
* Environment-aware bucket deployment

---

# Environment Strategy

Branch-based deployment strategy:

```text
dev      -> development
staging  -> staging
main     -> production
```

Terraform environment selection is handled dynamically using:

```bash
TF_ENV
```

Each environment contains isolated Terraform configuration:

```text
terraform/environments/dev
terraform/environments/staging
terraform/environments/production
```

---

# Kubernetes Deployments

The cluster hosts separate deployments for each environment:

* game-backend-dev
* game-backend-staging
* game-backend-production

Deployments are updated through GitLab CI/CD using:

```bash
kubectl set image
```

---

# Docker Images

Images are stored in Google Artifact Registry:

```text
europe-west1-docker.pkg.dev/just-slots-499010/game-backend/api:$TAG
```

Environment tags:

* dev
* staging
* prod

---

# Terraform Modules

## registry

Creates Artifact Registry repositories.

---

## backend-workload

Creates:

* Deployments
* Services
* Ingress
* TLS configuration

---

## static-site

Creates frontend hosting buckets.

---

# How To Run

## Terraform

```bash
cd terraform/environments/*
terraform init
terraform plan
terraform apply
```

---

## Backend

```bash
cd apps/game-backend

docker build -t backend:test .
docker run -p 3000:3000 backend:test
```

---

## Frontend

```bash
cd apps/game-client/game-client

npm install
npm run build
npm run preview  ---->port:4173
npm run dev      ---->port:5173
```

---

# GitLab CI/CD Flow

## Development

```text
push -> dev branch -> automatic deploy
```

---

## Staging

```text
merge dev -> staging -> manual deploy
```

---

## Production

```text
merge staging -> main -> manual deploy
```

---

# Existing Infrastructure Used

The task was implemented using existing infrastructure resources:

* Existing GCP project:
  `just-slots-499010`

* Existing GKE cluster:
  `cluster-dev`

* Existing Artifact Registry repository

* External DNS managed using DuckDNS  --> DuckDNS.org

* TLS certificates managed through GKE ingress / managed certificates -> terraform/modules/backend-workload/ingress.tf
 ` kubectl get managedcertificate`
`NAME                      AGE     STATUS`
`backend-cert-dev          16h     Active`
`backend-cert-production   5h8m    Active`
`backend-cert-staging      5h21m   Active`

---

# Architecture

## Single Cluster / Multi Environment Setup
The infrastructure uses a single GKE cluster with logical separation between environments:

* dev
* staging
* production

Each environment has:

* separate Terraform environment configuration
* separate backend deployment
* separate frontend bucket
* separate DNS endpoint
* separate image tags

Environment selection is handled dynamically through GitLab CI/CD branch rules.

---

# Self-Hosted GitLab Setup

A self-hosted GitLab instance was used for the assignment.
URL : https://c1h3a3t7.duckdns.org/slot/devops-slot/
Additional setup performed:

* GitLab stable version deployment
* HTTPS configured using Certbot
* Local GitLab runner attached to the GitLab instance
* Docker Buildx enabled for linux/amd64 image builds

---

# Technical Challenges Encountered

## Docker Architecture Mismatch

One major deployment issue encountered was:

```text
ImagePullBackOff
```

This was caused by architecture mismatch between locally built Docker images and GKE node architecture.

### Root Cause

The local machine was building ARM-based Docker images while GKE worker nodes expected AMD64 images.

### Solution

Enabled Docker Buildx and forced AMD64 builds:

```bash
docker buildx build --platform linux/amd64
```

---

## GKE Resource Constraints

During deployment, pods occasionally failed scheduling because of insufficient memory on smaller nodes.

Initial configuration:

```hcl
node_config {
  machine_type = "e2-small"
  disk_size_gb = 20
  disk_type    = "pd-standard"
}
```

The issue was observed during rolling deployments where both old and new pods temporarily existed simultaneously.

---

# Security Notes

The implementation avoids storing long-lived credentials inside the repository.

Potential future improvements:

* Workload Identity
* Secret Manager integration
* RBAC hardening
* Separate namespaces per environment

---

# Future Improvements

The following improvements were intentionally left out to keep the submission focused on core DevOps functionality:

* Cloudflare proxy integration
* Workload Identity
* Secret Manager integration
* Horizontal Pod Autoscaler
* centralized monitoring / alerting stack
* reusable Terraform module publishing

With additional time, I would prioritize:

## Monitoring & Alerting

* Prometheus
* Grafana
* GCP Monitoring
* Log-based alerts

---

## Horizontal Pod Autoscaler (HPA)

Automatic scaling based on CPU and memory usage.

---

## Workload Identity

Replacing service-account based authentication with secure GCP identity federation.

---

## Secret Manager

Centralized secret storage and rotation.

---

## Advanced Deployment Strategies

* Canary deployments
* Blue/Green deployments

---

# Merge Request Flow

Terraform plans are automatically generated on Merge Requests.

This provides:

* Infrastructure review before apply
* Safer deployment workflow
* Plan artifact visibility

---

# Deliverables Included

This repository contains:

* Terraform infrastructure
* GitLab CI/CD pipelines
* Multi-environment setup
* Kubernetes deployment configuration
* Dockerized backend build process
* Frontend deployment pipeline
* Documentation

---

# Summary

The focus was placed on:

* simplicity
* reproducibility
* environment separation
* CI/CD automation
* modularity

# Danica Dimitrijevic
