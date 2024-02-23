# Field Guide: Energy Cloud Basic Environment

This field guide describes how to configure and build a scratch org with Energy and Utilities Cloud installed and configured to enable Omnistudio Metadata as well as Standard Runtime. Currently included in the basic environment:

- Scratch Org Definition file
- Package install (FSL and EUC)

## Set up an Energy Cloud scratch org

### Prerequisites

1. Install Vlocity Build Tool: `npm install -g vlocity`
2. Set the default dev hub: `sf config set target-dev-hub=my-dev-hub`
3. Request a local compiler key and store it in the `.npmrc` file: [Instructions](https://github.com/vlocityinc/vlocity_build?tab=readme-ov-file#support-for-omniscript--flexcards-local-compilation)

### Create an org

1. Run the script: `scripts/shell/build-sratch-org.sh`

## Backlog

- Sample Data
- Remote Site Settings & CORS
