# semantic-release
Repository for providing basic semantic-release library functionalities

## Inputs
| Input Parameter  | Required | Description                                                                |
|:----------------:|:--------:|----------------------------------------------------------------------------|
|     dry_run      |  false   | dry run - if only version should be returned without releasing new version |
| semantic_version |   true   | version of semantic-release to be used'                                    |

## Outputs
|       Input Parameter       | Description                                                    |
|:---------------------------:|:---------------------------------------------------------------|
|     new_release_version     | Version of the new release                                     |
|    new_release_published    | Whether a new release was published                            |                                                                       

## Example usage:

```yaml
# jobs section in GH actions  workflow file
jobs:
 release:
    name: Release new version
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        with:
          submodules: false
          persist-credentials: false
      - name: Semantic release
        id: semantic
        uses: splunk/semantic-release-action@v1
        with:
          semantic_version: 20
```