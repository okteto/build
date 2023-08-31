# GitHub Actions for Okteto Cloud

## Automate your development workflows using Github Actions and Okteto Cloud
GitHub Actions gives you the flexibility to build an automated software development workflows. With GitHub Actions for Okteto Cloud you can create workflows to build, deploy and update your applications in [Okteto Cloud](https://cloud.okteto.com).

Get started today with a [free Okteto Cloud account](https://cloud.okteto.com)!

## Github Action for Building your Containers in Okteto Cloud

You can use this action to build images from an [Okteto Manifest](https://www.okteto.com/docs/reference/cli/).

## Inputs

### `tag`

The image tag used for the build.

If `Dockerfile` is provided as `file` argument and no `tag` is provided, the image won't be pushed to the registry after the build.

When using Okteto Manifest for the build, the tag is inferred or used from the Manifest.

### `file`

The path to the Okteto Manifest or name of the Dockerfile.

## Example usage

This example runs the context action and then builds and pushes an image.

```yaml
# File: .github/workflows/workflow.yml
on: [push]

name: example

jobs:

  devflow:
    runs-on: ubuntu-latest
    steps:
    
    - uses: okteto/context@latest
      with:
        token: ${{ secrets.OKTETO_TOKEN }}
    
    - name: "Build"
      uses: okteto/build@latest
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

     - name: checkout
       uses: actions/checkout@master
       
     - uses: okteto/context@latest
       with:
         token: ${{ secrets.OKTETO_TOKEN }}
     
    - name: "Build"
      uses: okteto/build@latest
 ```
