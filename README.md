# DNS Management for M-Lab

## Summary
There are three primary zones for M-Lab:

Static
* measurementlab.net: website and web services, monitoring and non-platform.
* measurementlab.org: currently unused for the most part.

Dynamic
* measurement-lab.org: all servers part of the M-Lab platform.

The dynamic zone is generated and published by the siteinfo repository.

## Updating the measurement-lab.org zone
The siteinfo repository generates and publishes the zone to GCS, but deploying
it is done through an ansible playbook in the mlabops repository.  To make the
changes live, go to your clone of the *mlabops* repository and do:

```
# cd mlabops/ansible/dns
# ansible-playbook deploy_zone.yaml
```
