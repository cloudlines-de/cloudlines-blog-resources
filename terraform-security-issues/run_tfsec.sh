#!/bin/bash

cd ./repositories

for repo in $(ls .); do
    if [ -d "$repo" ]; then
	tfsec $repo --ignore-hcl-errors --soft-fail --format csv --out "$repo.csv" --no-module-downloads
    fi
done
