# semantic-release
Repository for providing basic semantic-release library functionalities.
Currently handling:
new_release_version
new_release_published

# Example usage:

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