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

> The directory name and json file name must be the same as the subgraph name.

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

#### ⚠️About subgraph.yaml in your project

You have to set startBlock explicitly! You can find the deployment height of the corresponding contract in the block explorer, otherwise we will refuse to deploy subgraph.

`dataSources -> source -> startBlock`

e.g.

```
...
schema:
  file: ./schema.graphql
dataSources:
  - kind: ethereum/contract
    name: Factory
    network: testnet
    source:
      address: '0x0000000000000000000000000000000000000000'
      abi: Factory
      startBlock: 5713000
...
```

### Creating a pull request

> How to crate a pull request？
>
> please see github Creating a pull request [docs](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request).

### Wait for the deploy subgraph

1. We'll review the pull request and merge.
2. Github action workflows execute deploy.
3. You can view the execution results in github [action](https://github.com/FunctionX/fx-subgraph/actions).

### Subgraph endpoints

- mainet
  * Queries (HTTP): `https://graph-node.functionx.io/subgraphs/name/{subgraph name}`
  * Subscriptions (WS): `https://graph-node.functionx.io/ws/subgraphs/name/{subgraph name}`
  * Subgraph indexing status: `https://graph-node-index.functionx.io`

- testnet
  * Queries (HTTP): `https://testnet-graph-node.functionx.io/subgraphs/name/{subgraph name}`
  * Subscriptions (WS): `https://testnet-graph-node.functionx.io/ws/subgraphs/name/{subgraph name}`
  * Subgraph indexing status: `https://testnet-graph-node-index.functionx.io`
  
### Checking subgraph health

  If a subgraph syncs successfully, that is a good sign that it will continue to run well forever. However, new triggers on the chain might cause your subgraph to hit an untested error condition or it may start to fall behind due to performance issues or issues with the node operators.
  Graph Node exposes a graphql endpoint which you can query to check the status of your subgraph. On the Hosted Service, it is available at https://graph-node-index.functionx.io/graphql. On a local node, it is available on port 8030/graphql by default. The full schema for this endpoint can be found here. Here is an example query that checks the status of the current version of a subgraph:
```
{
  indexingStatusForCurrentVersion(subgraphName: "subgraph name") {
    synced
    health
    fatalError {
      message
      block {
        number
        hash
      }
      handler
    }
    chains {
      chainHeadBlock {
        number
      }
      latestBlock {
        number
      }
    }
  }
}
```
  This will give you the chainHeadBlock which you can compare with the latestBlock on your subgraph to check if it is running behind. synced informs if the subgraph has ever caught up to the chain. health can currently take the values of healthy if no errors occurred, or failed if there was an error which halted the progress of the subgraph. In this case, you can check the fatalError field for details on this error.

### Subgraph archive policy
  The Hosted Service is a free Graph Node indexer. Developers can deploy subgraphs indexing a range of networks, which will be indexed, and made available to query via graphQL.
  To improve the performance of the service for active subgraphs, the Hosted Service will archive subgraphs that are inactive.
  A subgraph is defined as "inactive" if it was deployed to the Hosted Service more than 45 days ago, and if it has received 0 queries in the last 30 days.
  Developers can always redeploy an archived subgraph if it is required again.

## How do you deploy your own Graph Node

- download docker-compose.yarm

  `wget https://raw.githubusercontent.com/FunctionX/graph-node/fxcore/docker/docker-compose.yml`

- Set fxCore Web3 RPC address and EVM-enabled block height

> Note: fxCore nodes need to have pruning = "nothing" enabled. You can modify this by using fxcored config app.com Pruning Nothing

```
# mainnet
ethereum: 'mainnet:archive-node-url'
GRAPH_ETHEREUM_GENESIS_BLOCK_NUMBER: '5713000'

# testnet
ethereum: 'testnet:archive-node-url'
GRAPH_ETHEREUM_GENESIS_BLOCK_NUMBER: '3418880'
```

- start graph node

  `docker-compose up -d`