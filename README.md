# fx-subgraph

### Fork [fx-subgraph](https://github.com/functionx/fx-subgraph)

> How do fork a repo？
>
> please see github fork a repo [docs](https://docs.github.com/en/get-started/quickstart/fork-a-repo).

```shell
git clone https://github.com/<your github name>/fx-subgraph.git
cd fx-subgraph
```

### Add yourself subgraph space

* subgraph_name
  * must contain only a-z, A-Z, 0-9, '-' and '_'.
  * cannot be repeated.
* network
  * your can be set to mainnet or testnet.
* version
  * the version that needs to be updated.
* last_version
  * update the previous version.
* github_repo
  * the github repository URL of the subgraph(must be public).
* branch
  * git branch or commit hash.

> The update will only be performed if the version is not the same as the last version.

> The `<subgraph name>.json` contains arrays of length less than or equal to 2; A test network and mainnet subgraph

```shell
mkdir <subgraph name>

touch <subgraph name>/<subgraph name>.json

cat << EOF > <subgraph name>/<subgraph name>.json
[
  {
    "subgraph_name": "fx-swap",
    "network": "testnet",
    "version": "v1.0.0",
    "last_version": "v0.0.0",
    "github_repo": "https://github.com/*/*.git",
    "branch": "main"
  }
]
EOF
```

e.g.

```shell
mkdir template

touch template/template.json

cat <<EOF > template/template.json
[
  {
    "subgraph_name": "template",
    "network": "mainnet",
    "version": "v0.0.0",
    "last_version": "v0.0.0",
    "branch": "main",
    "github_repo": "https://github.com/functionx/fx-subgraph.git"
  }
  {
    "subgraph_name": "template",
    "network": "testnet",
    "version": "v0.1.0",
    "last_version": "v0.0.0",
    "branch": "main",
    "github_repo": "https://github.com/functionx/fx-subgraph.git"
  }
]
EOF
```

### Creating a pull request

> How to crate a pull request？
>
> please see github Creating a pull request [docs](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request).

