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

RES=$(sf project deploy start --metadata-dir managed_packages/fsl_package --wait 1 -o "${ORG_NAME}")
if [ "$?" = "1" ]
then
  echo "--> "
    echo "--> ERROR: Can't install FSL."
  echo "--> "
    read -n 1 -s -r -p "--> Press any key to continue"
    exit
fi

echo "--> "
echo "--> FSL installed successfully..."

# INSTALL SFI

RES=$(sf project deploy start --metadata-dir managed_packages/vlocity_package -o "${ORG_NAME}")

if [ "$?" = "1" ]
then
  echo "--> "
    echo "--> ERROR: Can't install Salesforce Industries."
  echo "--> "
    read -n 1 -s -r -p "--> Press any key to continue"
    exit
fi

echo "--> "
echo "--> Salesforce Industries CMT installed successfully..."
echo "--> "
echo "--> Setting object permissions"
echo "--> "

vlocity -sfdx.username "${ORG_NAME}" --nojob runJavaScript -js updateProfile.js

echo "--> "
echo "--> Done with that."




read -n 1 -s -r -p "--> Press any key to continue"
echo " "