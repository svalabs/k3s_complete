# k3s_complete
This Repository will contain all necessary elements for deploying K3S with multi master on Hetzner / VMware with MetalLB

## Features
  - Install K3s Multi Master Setup
  - Support for VMware / Hetzner Cloud
  - Nodes are specified by array. You can automagically let ansible create as many master and worker as desired
  - Implement MetalLB
  - Implement Azure DNS
  - Implement Certmanager for LetsEncrypt with DNS Validation for Azure DNS
  - Create Deploymentfiles
  - Create MySQL Node with specified DBs
  - Dynamic Inventory for VMware / Hetzner Cloud

## Necessary Python Packages
  - pyvmomi
  - pyvim
  - pyOpenSSL
  - requests

## VMware specifiy Requirements
  - please fill in authentication data to vcenter.vmware.yml for using dynamic inventory
  - if you don't have a template image for new nodes, you can use vmware_create_image role, which utilizes packer for creating a ubuntu 20.04 lts vm with user: ubnt, password: ubnt
    - just fill in your vmware auth data in json and start it

## Hetzner Cloud specific Requirements
  - HCLOUD Token needs to be available as env variable (export HCLOUD_TOKEN=""...)
  - Python Package for hcloud api needs to be available on ansible host
  - please specify server_stack name in hcloud.yaml for dynamic inventory
  - Hetzner Cloud LB not implemented. TBD...

# Azure DNS specific Requirements
  - please ensure, that you point a wildcard type A record for all subzones of the desired dns zone to the external traefik ip or otherwise add every service dns name to this ip
  - Working Deployment for each service with lets encrypt intergration and certmanager
  - You have to create an App Registration with the permissions (DNS TXT Contributor) for your DNS Zone

# OVH DNS specifiy Requirements
  - until now only used for cluster access, not for deployed services so far
  - will use dyndns feature from ovh (experimental)