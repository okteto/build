# GitHub Actions for Okteto

## Automate your development workflows using Github Actions and Okteto

GitHub Actions gives you the flexibility to build automated software development workflows. With GitHub Actions for Okteto you can create workflows to build, deploy and update your applications in [Okteto](https://www.okteto.com).

Try Okteto for free for 30 days, no credit card required. [Start your 30-day trial now](https://www.okteto.com/free-trial/)!

## Github Action for Building your Containers in Okteto

You can use this action to build images from an [Okteto Manifest](https://www.okteto.com/docs/reference/manifest/).

## Inputs

### `tag`

Name and optionally a tag in the `name:tag` format for the build. When `file` points to a `Dockerfile`, in order to push the image to a registry, a `tag` is required. Otherwise, the build would be done but no image will be pushed to the registry.

### `file`

The relative path to the Okteto Manifest.

> You can also use this input to point to a Dockerfile. In this mode, okteto build will ignore your Okteto manifest, and directly build the image defined in the Dockerfile. Use this to build images that are not defined on your Okteto manifest.

### `path`

Service from the Okteto Manifest to build. You can select the service to build providing the `path`, otherwise all images at the Okteto Manifest build definition would be build.

When repository does not have an Okteto Manifest or `Dockerfile` is provided at `file`, `path` is the execution path of the action. .

### `buildargs`

A list of comma-separated build arguments.

### `target`

Specific target stage to build image. Only available when `file` refers to a Dockerfile instead of an Okteto Manifest.

### `no-cache`

Set to "true" when no cache should be used when building the image

### `cache-from`

A list of comma-separated images where cache should be imported from. Specific target stage to build image. Only available when `file` refers to a Dockerfile instead of an Okteto Manifest.

### `export-cache`

A list of comma-separated images where cache should be exported to.

### `secrets`

A list of semi-colon secrets. Each with format: id=mysecret,src=/local/secret. Only available with a Dockerfile file.

### `platform`

A list of semi-colon target platforms to build

### `log-level`

Log level used. Supported values are: `debug`, `info`, `warn`, `error`. (defaults to warn)

## Example usage

### Build and push images for all services described at an Okteto Manifest

This example runs the context action `okteto/context@latest` and then builds and pushes an image. A valid Okteto Manifest should exist at the repository.

```yaml
# File: .github/workflows/workflow.yml
on: [push]

name: example

concurrency:
  # more info here: https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#concurrency
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: false

jobs:
  devflow:
    runs-on: ubuntu-latest
    steps:
      - uses: okteto/context@latest
        with:
          url: https://okteto.example.com
          token: ${{ secrets.OKTETO_TOKEN }}

      - name: "Build"
        uses: okteto/build@latest
```

### Build and push images for single service described in the Okteto Manifest

This example runs the context action `okteto/context@latest` and then builds and pushes the image for the service `service`. A valid Okteto Manifest should exist at the repository.

```yaml
# File: .github/workflows/workflow.yml
on: [push]

name: example

jobs:
  devflow:
    runs-on: ubuntu-latest
    steps:
      - name: "Context Setup"
        uses: okteto/context@latest
        with:
          url: https://okteto.example.com
          token: ${{ secrets.OKTETO_TOKEN }}

      - name: "Build"
        uses: okteto/build@latest
        with:
          path: service
```

### Build and push images that are not defined in your Okteto manifest.

This example sets the context, and then builds an image that is not defined in the Okteto Manifest.

```yaml
# File: .github/workflows/workflow.yml
on: [push]

name: example

jobs:
  devflow:
    runs-on: ubuntu-latest
    steps:
      - name: "Context Setup"
        uses: okteto/context@latest
        with:
          url: https://okteto.example.com
          token: ${{ secrets.OKTETO_TOKEN }}

      - name: "Build"
        uses: okteto/build@latest
        with:
          tag: myapp-backend:latest
          file: Dockerfile
          path: backend
```

If `tag` is not provided, the image won't be pushed to the registry.

## Advanced usage

### Custom Certification Authorities or Self-signed certificates

You can specify a custom certificate authority or a self-signed certificate by setting the `OKTETO_CA_CERT` environment variable. When this variable is set, the action will install the certificate in the container, and then execute the action.

Use this option if you're using a private Certificate Authority or a self-signed certificate in your [Okteto SH](https://www.okteto.com/docs/self-hosted/) instance. We recommend that you store the certificate as an [encrypted secret](https://docs.github.com/en/actions/reference/encrypted-secrets), and that you define the environment variable for the entire job, instead of doing it on every step.

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

    - name: "Context Setup"
      uses: okteto/context@latest
      with:
        url: https://okteto.example.com
        token: ${{ secrets.OKTETO_TOKEN }}

    - name: "Build"
      uses: okteto/build@latest
```
