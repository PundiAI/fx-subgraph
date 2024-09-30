#!/bin/bash

set -o errexit -o pipefail

untracked_files="$(git ls-files --others --exclude-standard)"
if [[ -n "${untracked_files}" && -d "./${untracked_files}" ]]; then
  echo "untracked files: ./${untracked_files}"
  rm -rf "./${untracked_files}"
fi

changeSubgraph=$(find . -name '*.json' -not -path "./node_modules/*" | grep '[_a-zA-Z0-9-]*.\/[_a-zA-Z0-9-]*.\.json')

for subgraph in ${changeSubgraph}; do
  subgraphName=$(dirname "${subgraph:2}")
  if [[ ! -d "${subgraphName}" || "${subgraphName}.json" != "$(basename "${subgraph}")" ]]; then
    echo "invalid subgraph: ${subgraph}" && exit 1
  fi
  subgraphNumber=$(jq -r '. | length' "${subgraph}")
  if [ "${subgraphNumber}" -gt 2 ]; then
    echo "can only contain one testnet and mainnet subgraph: ${subgraph}" && exit 1
  fi
  if [ "${subgraphNumber}" -le 0 ]; then
    continue
  fi
  for info in $(jq -r '.[] | @base64' "${subgraph}"); do
    _jq() {
      echo "${info}" | base64 --decode | jq -r "${1}"
    }
    if [ "${subgraphName}" != "$(_jq '.subgraph_name')" ]; then
      echo "invalid subgraph name: $(_jq '.subgraph_name')"
      continue
    fi
    lastVersion=$(_jq '.last_version')
    version=$(_jq '.version')
    if [ "${lastVersion}" == "${version}" ]; then
      echo "no update ${subgraph}"
      continue
    fi
    network="$(_jq '.network')"
    if [ "${network}" == "mainnet" ]; then
      graphNodeUrl="${GRAPH_NODE_URL}"
      ipfsUrl="${GRAPH_IPFS_URL}"
      graphNodePubUrl="https://graph-node.functionx.io"
    elif [ "${network}" == "testnet" ]; then
      graphNodeUrl="${TESTNET_GRAPH_NODE_URL}"
      ipfsUrl="${TESTNET_GRAPH_IPFS_URL}"
      graphNodePubUrl="https://testnet-graph-node.functionx.io"
    else
      echo "invalid network: $network"
      continue
    fi
    githubRepo=$(_jq '.github_repo')
    if [ "${githubRepo:0:18}" != "https://github.com" ]; then
      echo "invalid github repository URL: ${githubRepo}"
      continue
    fi
    if [ "${githubRepo:0-4:4}" == ".git" ]; then
      githubRepo="${githubRepo%????}"
    fi
    branch=$(_jq '.branch')
    curl --connect-timeout 3 -s https://raw.githubusercontent.com/"${githubRepo:19}"/"${branch}"/package.json | jq .
    if [ ! -d "${subgraphName}_${version}/.git" ]; then
      git clone -b "${branch}" "${githubRepo}" "${subgraphName}_${version}"
    fi
    cd "${subgraphName}_${version}" || exit 1
    echo "update ${subgraph}: form ${lastVersion} to ${version} in the ${network}"
    if [ -f "yarn.lock" ]; then
      yarn install
      yarn codegen
    else
      npm install
      npm run codegen
    fi
    npx graph build
    if [[ ${lastVersion} == "v0.0.0" ]]; then
      echo "Creating subgraph ${subgraphName} on Graph node"
      if ! npx graph create --node "${graphNodeUrl}" "${subgraphName}"; then
        echo "Failed to create ${subgraphName}!" && cd ..
        continue
      fi
    fi
    echo "Deploying subgraph ${subgraphName} to Graph node"
    npx graph deploy --ipfs "${ipfsUrl}" --node "${graphNodeUrl}" "${subgraphName}"
#    if npx graph deploy --ipfs "${ipfsUrl}" --node "${graphNodeUrl}" "${subgraphName}"; then
#      echo "Deploying to Graph node"
#      echo "Deployed to $graphNodePubUrl/subgraphs/name/${subgraphName}/graphql"
#      echo "Subgraph endpoints:"
#      echo "Queries (HTTP): $graphNodePubUrl/subgraphs/name/${subgraphName}"
#      echo "Subscriptions (WS): $graphNodePubUrl/ws/subgraphs/name/${subgraphName}"
#    else
#      echo "Failed to deploy ${subgraphName}!"
#    fi
    cd .. || exit 1
  done
done
