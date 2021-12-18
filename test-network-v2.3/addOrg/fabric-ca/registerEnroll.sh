#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

function createOrg3 {
	infoln "Enrolling the CA admin"
	mkdir -p ../organizations/peerOrganizations/org$1.example.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/org$1.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:$((7054+2000*$(($1-1)))) --caname ca-org$1 --tls.certfiles "${PWD}/fabric-ca/org$1/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-'$((7054+2000*$(($1-1))))'-ca-org'$1'.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-'$((7054+2000*$(($1-1))))'-ca-org'$1'.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-'$((7054+2000*$(($1-1))))'-ca-org'$1'.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-'$((7054+2000*$(($1-1))))'-ca-org'$1'.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/../organizations/peerOrganizations/org$1.example.com/msp/config.yaml"

	infoln "Registering peer0"
  set -x
	fabric-ca-client register --caname ca-org$1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/fabric-ca/org$1/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-org$1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/fabric-ca/org$1/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-org$1 --id.name org$1admin --id.secret org$1adminpw --id.type admin --tls.certfiles "${PWD}/fabric-ca/org$1/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:$((7054+2000*$(($1-1)))) --caname ca-org$1 -M "${PWD}/../organizations/peerOrganizations/org$1.example.com/peers/peer0.org$1.example.com/msp" --csr.hosts peer0.org$1.example.com --tls.certfiles "${PWD}/fabric-ca/org$1/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/../organizations/peerOrganizations/org$1.example.com/msp/config.yaml" "${PWD}/../organizations/peerOrganizations/org$1.example.com/peers/peer0.org$1.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:$((7054+2000*$(($1-1)))) --caname ca-org$1 -M "${PWD}/../organizations/peerOrganizations/org$1.example.com/peers/peer0.org$1.example.com/tls" --enrollment.profile tls --csr.hosts peer0.org$1.example.com --csr.hosts localhost --tls.certfiles "${PWD}/fabric-ca/org$1/tls-cert.pem"
  { set +x; } 2>/dev/null


  cp "${PWD}/../organizations/peerOrganizations/org$1.example.com/peers/peer0.org$1.example.com/tls/tlscacerts/"* "${PWD}/../organizations/peerOrganizations/org$1.example.com/peers/peer0.org$1.example.com/tls/ca.crt"
  cp "${PWD}/../organizations/peerOrganizations/org$1.example.com/peers/peer0.org$1.example.com/tls/signcerts/"* "${PWD}/../organizations/peerOrganizations/org$1.example.com/peers/peer0.org$1.example.com/tls/server.crt"
  cp "${PWD}/../organizations/peerOrganizations/org$1.example.com/peers/peer0.org$1.example.com/tls/keystore/"* "${PWD}/../organizations/peerOrganizations/org$1.example.com/peers/peer0.org$1.example.com/tls/server.key"

  mkdir "${PWD}/../organizations/peerOrganizations/org$1.example.com/msp/tlscacerts"
  cp "${PWD}/../organizations/peerOrganizations/org$1.example.com/peers/peer0.org$1.example.com/tls/tlscacerts/"* "${PWD}/../organizations/peerOrganizations/org$1.example.com/msp/tlscacerts/ca.crt"

  mkdir "${PWD}/../organizations/peerOrganizations/org$1.example.com/tlsca"
  cp "${PWD}/../organizations/peerOrganizations/org$1.example.com/peers/peer0.org$1.example.com/tls/tlscacerts/"* "${PWD}/../organizations/peerOrganizations/org$1.example.com/tlsca/tlsca.org$1.example.com-cert.pem"

  mkdir "${PWD}/../organizations/peerOrganizations/org$1.example.com/ca"
  cp "${PWD}/../organizations/peerOrganizations/org$1.example.com/peers/peer0.org$1.example.com/msp/cacerts/"* "${PWD}/../organizations/peerOrganizations/org$1.example.com/ca/ca.org$1.example.com-cert.pem"

  infoln "Generating the user msp"
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:$((7054+2000*$(($1-1)))) --caname ca-org$1 -M "${PWD}/../organizations/peerOrganizations/org$1.example.com/users/User1@org$1.example.com/msp" --tls.certfiles "${PWD}/fabric-ca/org$1/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/../organizations/peerOrganizations/org$1.example.com/msp/config.yaml" "${PWD}/../organizations/peerOrganizations/org$1.example.com/users/User1@org$1.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
	fabric-ca-client enroll -u https://org$1admin:org$1adminpw@localhost:$((7054+2000*$(($1-1)))) --caname ca-org$1 -M "${PWD}/../organizations/peerOrganizations/org$1.example.com/users/Admin@org$1.example.com/msp" --tls.certfiles "${PWD}/fabric-ca/org$1/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/../organizations/peerOrganizations/org$1.example.com/msp/config.yaml" "${PWD}/../organizations/peerOrganizations/org$1.example.com/users/Admin@org$1.example.com/msp/config.yaml"
}