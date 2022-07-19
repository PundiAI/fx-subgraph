# fx-subgraph

### Fork [fx-subgraph](https://github.com/functionx/fx-subgraph)

> How do fork a repo？
>
> please see github fork a repo [docs](https://docs.github.com/en/get-started/quickstart/fork-a-repo)

```shell
git clone https://github.com/<your github name>/fx-subgraph.git
cd fx-subgraph
```

### Add yourself subgraph space

* subgraph_name
    * must contain only a-z, A-Z, 0-9, '-' and '_'
    * cannot be repeated
* network
    * your can be set to mainnet or testnet

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
    "branch": "main",
    "github_repo": "https://github.com/*/*.git"
  }
]
EOF
```

e.g.

```shell
mkdir fx-swap

touch fx-swap/fx-swap.json

cat <<EOF > fx-swap/fx-swap.json
[
  {
    "subgraph_name": "fx-swap",
    "network": "mainnet",
    "version": "v1.0.0",
    "last_version": "v0.0.0",
    "branch": "main",
    "github_repo": "https://github.com/functionx/fx-swap.git"
  }
  {
    "subgraph_name": "fx-swap",
    "network": "testnet",
    "version": "v1.0.0",
    "last_version": "v0.0.0",
    "branch": "test",
    "github_repo": "https://github.com/functionx/fx-swap.git"
  }
]
EOF
```

### Creating a pull request

> How to crate a pull request？
>
> please see github Creating a pull
>
request [docs](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)

