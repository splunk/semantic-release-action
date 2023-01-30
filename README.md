# semantic-release-action
Repository for providing basic semantic-release library functionalities as a GitHub action.

## Inputs
| Input Parameter  | Required | Description                                                                |
|:----------------:|:--------:|----------------------------------------------------------------------------|
|     dry_run      |  false   | dry run - if only version should be returned without releasing new version |
|   extra_plugins  |  false   | extra plugins - if additional plugins are to be installed                  |

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
          extra_plugins: |
            @google/semantic-release-replace-plugin
```
