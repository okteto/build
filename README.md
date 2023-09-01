# GitHub Actions for Okteto Cloud

## Automate your development workflows using Github Actions and Okteto Cloud

GitHub Actions gives you the flexibility to build an automated software development workflows. With GitHub Actions for Okteto Cloud you can create workflows to build, deploy and update your applications in [Okteto Cloud](https://cloud.okteto.com).

Get started today with a [free Okteto Cloud account](https://cloud.okteto.com)!

## Github Action for Building your Containers in Okteto Cloud

You can use this action to build images from an [Okteto Manifest](https://www.okteto.com/docs/reference/cli/).

## Inputs

### `tag`

Name and optionally a tag in the `name:tag` format for the build. When `file` points to a `Dockerfile`, in order to push the image to a registry, a `tag` is required. Otherwise, the build would be done but no image will be pushed to the registry.

### `file`

Path to the Okteto Manifest. If no `file` is provided, `okteto build` will lookup for the Okteto Manifest file.

You can also use the `file` to point to a `Dockerfile`. In this mode, `okteto build` will ignore your Okteto Manifest, and directly build the image defined in the `Dockerfile`. Use this to build images that are not defined on your Okteto Manifest.

### `path`

Service from the Okteto Manifest to build. You can select the service to build providing the `path`, otherwise all images at the Okteto Manifest build definition would be build.

When repository does not have an Okteto Manifest of `Dockerfile` is provided at `file`, `path` determines the context where the build should run.

### `buildargs`

A list of comma-separated build arguments.

## Example usage

### Build and push images for all services described at an Okteto Manifest

This example runs the context action `okteto/context@latest` and then builds and pushes an image. A valid Okteto Manifest should exist at the repository.

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

### Build and push images for single service described at an Okteto Manifest

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
          token: ${{ secrets.OKTETO_TOKEN }}

      - name: "Build"
        uses: okteto/build@latest
        with:
          path: service
```

### Build and push images that are not defined on your Okteto manifest.

This example runs the context action `okteto/context@latest` and then builds and pushes the image for a Dockerfile not included at the Okteto Manifest.

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
          token: ${{ secrets.OKTETO_TOKEN }}

      - name: "Build"
        uses: okteto/build@latest
        with:
          tag: myapp:latest
          file: Dockerfile
          path: "."
```

If `tag` is not provided, the image won't be pushed to the registry.

## Advanced usage

### Custom Certification Authorities or Self-signed certificates

You can specify a custom certificate authority or a self-signed certificate by setting the `OKTETO_CA_CERT` environment variable. When this variable is set, the action will install the certificate in the container, and then execute the action.

Use this option if you're using a private Certificate Authority or a self-signed certificate in your [Okteto Enterprise](http://okteto.com/enterprise) instance. We recommend that you store the certificate as an [encrypted secret](https://docs.github.com/en/actions/reference/encrypted-secrets), and that you define the environment variable for the entire job, instead of doing it on every step.

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
        token: ${{ secrets.OKTETO_TOKEN }}

    - name: "Build"
      uses: okteto/build@latest
```
