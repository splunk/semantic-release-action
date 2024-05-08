# semantic-release-action
Repository for providing basic semantic-release library functionalities as a GitHub Action.

## Inputs
| Input Parameter  | Required | Description                                                                 |
|:-----------------:|:--------:|----------------------------------------------------------------------------|
|     dry_run       |  false   | dry run - if only version should be returned without releasing new version |
|   extra_plugins   |  false   | extra plugins - if additional plugins are to be installed                  |
|git_committer_name |  false   | git commiter name - name of commiter used to sign bot commits              |
|git_committer_email|  false   | git commiter email - email address of committer used to sign bot commits   |
|  gpg_private_key  |  false   | gpg private key - key associated with committer                            |
|    passphrase     |  false   | passphrase - passphrase for gpg private key                                |



## Outputs
|       Output Parameter       | Description                                                   |
|:---------------------------:|:---------------------------------------------------------------|
|     new_release_version     | Version of the new release                                     |
|    new_release_published    | Whether a new release was published                            |                                                                     

## Example usage:

```yaml
# jobs section in GitHub Actions workflow file 
jobs:
 release:
    name: Release new version
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: false
          persist-credentials: false
      - name: Semantic release
        id: semantic
        uses: splunk/semantic-release-action@v1.3
        env:
          GITHUB_TOKEN: ${{ secrets.GH_TOKEN_ADMIN }}
        with:
          git_committer_name: ${{ secrets.SA_GH_USER_NAME }}
          git_committer_email: ${{ secrets.SA_GH_USER_EMAIL }}
          gpg_private_key: ${{ secrets.SA_GPG_PRIVATE_KEY }}
          passphrase: ${{ secrets.SA_GPG_PASSPHRASE }}
          extra_plugins: |
            @google/semantic-release-replace-plugin
```
