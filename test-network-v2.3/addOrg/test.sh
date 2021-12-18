#! /bin/bash

# Edit ccp-generate.sh
sed -i '16 i  \ ' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Rule: "OR('Org$1MSP.peer')"' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Type: Signature' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ \ \ \ \ Endorsement:' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Rule: "OR('Org$1MSP.admin')"' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Type: Signature' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ \ \ \ \ Admins:' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Rule: "OR('Org$1MSP.admin', 'Org$1MSP.client')"' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Type: Signature' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ \ \ \ \ Writers:' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Rule: "OR('Org$1MSP.admin', 'Org$1MSP.peer', 'Org$1MSP.client')"' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Type: Signature' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ \ \ \ \ Readers:' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ Policies:' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ MSPDir: ../organizations/peerOrganizations/org'$1'.example.com/msp' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ ID: Org'$1'MSP' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ \ \ \ \ Name: Org'$1'MSP' ${PWD}/configtx.yaml
sed -i '16 i \ \ \ \ - &Org'$1'' ${PWD}/configtx.yaml