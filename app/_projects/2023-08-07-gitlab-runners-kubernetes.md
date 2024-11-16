---
title: Install Gitlab Runners on Kubernetes
subtitle: Gitlab 16.0+ Method for creating Gitlab Runners on Kubernetes
description: In GitLab 16.0, a new runner creation workflow was introduced that uses authentication tokens to register runners. The legacy workflow that uses registration tokens is deprecated and will be removed in GitLab 17.0.Gitlab GUI
date: 2023-08-07 00:00:00
featured_image: /images/site-assets/sidebar-3.jpg
---

As the title suggests, there are new ways of configuring Gitlab Runners, we will be starting the process in the GITLAB Web GUI

1. Go to Settings > CI/CD in a Project
2. Select Runners > New Runner
3. Select Linux; Write a tag, description, and edit configurations if desired.

NOTE: Runner TAGS are depreciated in the TOML/ HELM, so this is where they are set now.Copy the runner token, and save it in 1Pass or Vault, if you are using Kubernetes, we will need it for the next step. 


Follow the steps on the in order to use this runner token in Kubernetes, you will need to Base64 Encode it for the Secret. 
```
  echo -n 'glrt-isC-rVy7MUy1cWoxrV4b' | base64 
```

Depending if one exists, we may need to make a namespace, make sure you use this namespace throughout this deployment:

```
  kubectl create namespace gitlab-runner
```

Create the Kubernetes manifest for the Secret in the namespace for the gitlab runner, we will call it secret.yml (can be named anything). We are going to copy our base64 encoded string into the `runner-token:` in our maifest

```
  apiVersion: v1
kind: Secret
metadata:
  name: gitlab-runner-secret
  namespace: gitlab-runner
  type: Opaque
data:
  runner-registration-token: "" # need to leave as an empty string for compatibility reasons
  runner-token: "Z2xydC1pc0MtclZ5N01VeTFjV294clY0Yg==" # This is our Base64 string 

```
 
Apply the secret to the namespace:

 ```
kubectl apply -f secret.yml 
 ```
 
 
### Helm Chart

This is the fun part, we will be using a Helmfile for this deployment, which uses the helm chart by gitlab for the deployment of the app gitlab-runner. We can specify the token in the helmfile.yml or in the values file, I will attach more info in the INFO section with a link to ArtifactHub.Here is the Helmfile.yml using the external values file (recommended since we have RBAC also attached):
 
Helmfile.yml using gl-runner-values.yaml
 
 ```
   repositories:
  - name: gitlab
    url: https://charts.gitlab.io
releases:
  - name: gitlab-runner #Custom Name of this release
    chart: gitlab/gitlab-runner #Chart from the repo we are using
    namespace: gitlab-runner # target namespace
    createNamespace: true # create a namespace if it doesn't exist
    version: 0.55.0 # what version of the Helmchart we are using, see Artifacthub for version differences
    installed: true # restores previous state in case of failed release (default false)
    # Values files used for configuring the chart
    values:
  - gl-runner-values.yaml 
 ```


 
While there are many values and settings we can set, Only crucial ones will be listed in this documentation. For a full list of available values, see the ArtifaktHub Chart
 ```
### gl-runner-values.yaml 

## GitLab Runner Image
image:
  registry: registry.gitlab.com
  image: gitlab-org/gitlab-runner

imagePullPolicy: IfNotPresent

# This needs to be set
gitlabUrl: https://gitlab.com/

# This is a case by case, by default we set to true
unregisterRunners: true

# How many runner pods to launch.
##
replicas: 1 # can specify more, however currently does not by default autoscale


## Configure the maximum number of concurrent jobs
## ref: https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-global-section
## 
concurrent: 10 # specify your desired amount

#RBAC is a bit complicated, however we have this set to lock down the runners to do only necessary tasks as of writing this. Disposable ENVs and other deployments will vary rules, see the documentation and logs for what to add on a case by case basis

## For RBAC support:
rbac:
  create: true
  rules:
   - resources: ["deployments", "configmaps", "pods", "pods/attach", "pods/exec", "secrets", "services", "namespaces", "serviceaccounts", "ingressroutes", "middlewares", "replicationcontrollers", "daemonsets", "statefulsets", "jobs", "cronjobs", "replicasets", "horizontalpodautoscalers"]
     apiGroups: ["*"]
     verbs: ["get", "list", "watch", "create", "patch", "delete", "update"]
### Helm updates:
   - resources: ["clusterroles", "clusterrolebindings", "mutatingwebhookconfigurations", "mutatingwebhookconfigurations.admissionregistration.k8s.io", "secrets", "events"]
     apiGroups: ["*"]
     verbs: ["get", "patch", "update", "create", "list", "watch"]

  ## Run the gitlab-bastion container with the ability to deploy/manage containers of jobs
  ## cluster-wide or only within namespace
  clusterWideAccess: true

  ## Use the following Kubernetes Service Account name if RBAC is disabled in this Helm chart (see rbac.create)
  ## This is important to specify the name of Service Account that will use RBAC specified above, and will need to call for it again in the runner config
  ##
  serviceAccountName: gitlab-runner 

## Configuration for the Pods that the runner launches for each new job
##
runners:
  config: |
    [[runners]]
      [runners.kubernetes]
        namespace = "{{.Release.Namespace}}"
        image = "ubuntu:16.04" # can use ubuntu:20.04, oddly Gitlab contiunally suggests this one
        service_account = "gitlab-runner" # make sure the name of this matches the serviceAccountName specified above or runs will fail
        service_account_overwrite_allowed = ".*"
        pull_policy = ["always", "if-not-present"]

  ## Which executor should be used:
  executor: kubernetes

  ## Specify the name for the runner.
  ##
  name: "gitlab-new-runner"

  ## The name of the secret containing runner-token
  ##
  ## This is the Secret we created earlier
  ##
  secret: gitlab-runner-secret  
``` 

Apply the Helmfile:

```
helmfile apply -f helmfile.yml
```

If done correctly, you should see these runners in your gitlab :) 


Documentation:
- Gitlab Documentation: https://docs.gitlab.com/ee/ci/runners/new_creation_workflow.html
- ArtifactHUB for Gitlab Runner (where we can see Helm values): https://artifacthub.io/packages/helm/gitlab/gitlab-runner
- Helmfile: https://github.com/helmfile/helmfile#installation
- Helm: https://helm.sh/docs/intro/install/#from-homebrew-macos

