#!/bin/sh
#set -x
 
echo ===========Output CLI version===========
sf --version
echo =============Output org list===========
sf org list
echo "--> "
echo "--> "
echo "--> Time to enter a good name for your scratch org..."
echo "--> Example: visser-test"
echo "--> "
while [ ! -n "$ORG_NAME"  ]
do
    echo "-->  Please enter a name for your scratch org:"
    echo " "
    read ORG_NAME
    echo " "
done

while [ ! -n "$ORG_DESC"  ]
do
    echo "-->  Please enter a description for your scratch org:"
    echo " "
    read ORG_DESC
    echo " "
done

# START OF CREATING ORG
 
echo "--> "
echo "--> Building your org, please wait..."
RES=$(sf org create scratch --definition-file config/energy-cloud-scratch-def.json --duration-days 30 --alias "${ORG_NAME}" --name "${ORG_NAME}" --description "${ORG_DESC}")

 
if [ "$?" = "1" ]
then
  echo "--> "
    echo "--> ERROR: Can't create your org."
  echo "--> "
    read -n 1 -s -r -p "--> Press any key to continue"
    exit
fi
 
echo "--> "
echo "--> Scratch org created successfully..."
echo "--> "
echo "--> Before installing managed packages enable Omnistudio Metadata and disable Package Runtime in the scratch org (currently this feature is not working from definition files)."
echo "--> "
read -n 1 -s -r -p "--> Press any key to continue"

# INSTALL FSL

RES=$(sf project deploy start --metadata-dir managed_packages/fsl_package --wait 180 -o "${ORG_NAME}")
if [ "$?" = "1" ]
then
  echo "--> "
  echo "--> Oops: Timeout, let's try reopen deploy"
  sf project deploy resume --use-most-recent
fi

echo "--> "
echo "--> FSL installed successfully..."

# INSTALL SFI

RES=$(sf project deploy start --metadata-dir managed_packages/vlocity_package --wait 180 -o "${ORG_NAME}")

if [ "$?" = "1" ]
then
  echo "--> "
  echo "--> Oops: Timeout, let's try reopen deploy"
  sf project deploy resume --use-most-recent
fi

echo "--> "
echo "--> Salesforce Industries CMT installed successfully..."
echo "--> "
echo "--> Setting object permissions"
echo "--> "

vlocity -sfdx.username "${ORG_NAME}" --nojob runJavaScript -js updateProfile.js

echo "--> "
echo "--> Done with that."
echo "--> "
echo "--> Attempting to deploy CPQ cart..."
echo "--> "

vlocity -sfdx.username "${ORG_NAME}" -job scripts/vlocity/cart-omni.yaml packDeploy

echo "--> "
echo "--> After packDeploy errors:"

awk '/Error:/ {value = $2} END {print value}' VlocityBuildLog.yaml

vlocity -sfdx.username "${ORG_NAME}" -job scripts/vlocity/cart-omni.yaml packRetry

echo "--> "
echo "--> After packRetry #1 errors:"

awk '/Error:/ {value = $2} END {print value}' VlocityBuildLog.yaml

vlocity -sfdx.username "${ORG_NAME}" -job scripts/vlocity/cart-omni.yaml packRetry

echo "--> "
echo "--> After packRetry #2 errors:"

awk '/Error:/ {value = $2} END {print value}' VlocityBuildLog.yaml

vlocity -sfdx.username "${ORG_NAME}" -job scripts/vlocity/cart-omni.yaml packRetry

echo "--> "
echo "--> After packRetry #3 errors:"

awk '/Error:/ {value = $2} END {print value}' VlocityBuildLog.yaml

vlocity -sfdx.username "${ORG_NAME}" -job scripts/vlocity/cart-omni.yaml packRetry

echo "--> "
echo "--> After packRetry #4 errors:"

awk '/Error:/ {value = $2} END {print value}' VlocityBuildLog.yaml

vlocity -sfdx.username "${ORG_NAME}" -job scripts/vlocity/cart-omni.yaml packRetry

echo "--> "
echo "--> After packRetry #5 errors:"

awk '/Error:/ {value = $2} END {print value}' VlocityBuildLog.yaml

echo "--> "
echo "--> Updating metadata for target org"

#get Domain 
orgDomain=$(sf org display --json | jq -r '.result.instanceUrl' | cut -d'/' -f3 | cut -d'.' -f1)

#get Legacy Domain

sourceDomain=$(grep '<url>' sfi-cmt-base/main/default/remoteSiteSettings/force.remoteSite-meta.xml | sed "s@.*<url>\(.*\)</url>.*@\1@" | cut -d'/' -f3 | cut -d'.' -f1)

echo "Target Domain: $orgDomain"

echo "Source Code Domain: $sourceDomain"

grep -rl "$sourceDomain" ./sfi-cmt-base/main/default/remoteSiteSettings | xargs sed -i '' "s/\/$sourceDomain/\/$orgDomain/"

grep -rl "$sourceDomain" ./sfi-cmt-base/main/default/corsWhitelistOrigins | xargs sed -i '' "s/\/$sourceDomain/\/$orgDomain/"

echo "--> Done..."
echo "--> "
echo "--> Deploying metadata"

RES=$(sf project deploy start)

if [ "$?" = "1" ]
then
  echo "--> "
  echo "--> Oops: That didn't work!"
  read -n 1 -s -r -p "--> Press any key to continue"
  exit
fi

read -n 1 -s -r -p "--> Press any key to continue"
echo " "