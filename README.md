# GitHub Actions for Okteto Cloud

## Automate your development workflows using Github Actions and Okteto Cloud
GitHub Actions gives you the flexibility to build an automated software development workflows. With GitHub Actions for Okteto Cloud you can create workflows to build, deploy and update your applications in [Okteto Cloud](https://cloud.okteto.com).

Get started today with a [free Okteto Cloud account](https://cloud.okteto.com)!

## Github Action for Building your Containers in Okteto Cloud

You can use this action to build images from an [Okteto Manifest](https://www.okteto.com/docs/reference/cli/).

## Inputs

### `tag`

The name and (optionally) a tag to use for the impage, in the 'name:tag' format. If specified, the action will automatically push the image on a succesfull build.


### `file`

The relative path to the Okteto Manifest. Default `"okteto.yaml"`. 

> You can also use this input to point to a Dockerfile. In this mode, okteto build will ignore your Okteto manifest, and directly build the image defined in the Dockerfile. Use this to build images that are not defined on your Okteto manifest.

### `path`

The execution path of the action. 


### `buildargs`

A list of comma-separated build arguments. 

### `global`

When true will make the image available to everyone in your team. Default `false`.
Only admins can push images to the global registry.


## Example usage

This example sets the context, and then builds the images defined on the default `okteto.yaml` file.

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

### Build an image that is not defined in the manifest

This example sets the context, and then builds an image that is not defined in the Okteto manifest

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
      with:
        tag: registry.okteto.example.com/okteto/web-deps-cache:latest
        file: deps-cache.Dockerfile
        path: web
```


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
