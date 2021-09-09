# GitHub Actions for Okteto Cloud

## Automate your development workflows using Github Actions and Okteto Cloud
GitHub Actions gives you the flexibility to build an automated software development workflows. With GitHub Actions for Okteto Cloud you can create workflows to build, deploy and update your applications in [Okteto Cloud](https://cloud.okteto.com).

Get started today with a [free Okteto Cloud account](https://cloud.okteto.com)!

## Github Action for Building your Containers in Okteto Cloud

You can use this action to build an image from a Dockerfile using Okteto Cloud's build service.

## Inputs

### `tag`

**Required**  Name and tag in the `name:tag` format.

### `file`

Name of the Dockerfile. Default `"Dockerfile"`.

### `path`

The path to the files. Default `"."`.

### `buildargs`

A list of environment variables as build-args

```yaml
      env:
        PACKAGE_NAME: svc-api
        VCS_REF: ${{ github.sha }}
      with:
        buildargs: PACKAGE_NAME,VCS_REF
```

## Example usage

This example runs the login action and then builds and pushes an image.

```yaml
# File: .github/workflows/workflow.yml
on: [push]

name: example

jobs:

  devflow:
    runs-on: ubuntu-latest
    steps:
    
    - uses: okteto/login@latest
      with:
        token: ${{ secrets.OKTETO_TOKEN }}
    
    - name: "Build"
      uses: okteto/build@latest
      with:
        tag: okteto.dev/hello-world:${{ github.sha }}
```

## Advanced usage

 ### Custom Certification Authorities or Self-signed certificates

 You can specify a custom certificate authority or a self-signed certificate by setting the `OKTETO_CA_CERT` environment variable. When this variable is set, the action will install the certificate in the container, and then execute the action. 

 Use this option if you're using a private Certificate Authority or a self-signed certificate in your [Okteto Enterprise](http://okteto.com/enterprise) instance.  We recommend that you store the certificate as an [encrypted secret](https://docs.github.com/en/actions/reference/encrypted-secrets), and that you define the environment variable for the entire job, instead of doing it on every step.


 ```yaml
 # File: .github/workflows/workflow.yml
 on: [push]

 name: example

 jobs:
   devflow:
     runs-on: ubuntu-latest
     env:
       OKTETO_CA_CERT: ${{ secrets.OKTETO_CA_CERT }}
     steps:
     
     - uses: okteto/login@latest
       with:
         token: ${{ secrets.OKTETO_TOKEN }}
     
    - name: "Build"
      uses: okteto/build@latest
      with:
        tag: okteto.dev/hello-world:${{ github.sha }}
 ```