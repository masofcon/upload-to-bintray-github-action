# upload-to-bintray-github-action

Github action to upload files to JFrog Bintray via the [Bintray REST API](https://bintray.com/docs/api/).


## Example

```
name: Example

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1

    - name: Upload package to Bintray
      uses: masofcon/upload-to-bintray-github-action@master
      with:
        source_path: ./path/to/package.zip
        api_user: example-user
        api_key: ${{ secrets.BINTRAY_API_KEY }} # An API key can be obtained from the user profile page.
        repository: my_repository
        package: example-package
        version: '1.0'
        upload_path: path/in/repo
        publish: 1
        explode: 1
        override: 0
```