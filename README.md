# DNS Management for M-Lab

## Summary
There are three primary zones for M-Lab:

Static
* measurementlab.net: website and web services, monitoring and non-platform.
* measurementlab.org: currently unsed for the most part.

Dynamic
* measurement-lab.org: all servers part of the M-Lab platform.

The dynamic zone is generated by the script mlabconfig.py in the operator
repository (which is a submodule of this repo).

## Updating the measurement-lab.org zone
To regenerate the zone file for measurement-lab.org, do this:

`./gen-zone.sh`

The above command should update the zone file _measurement-lab.org_. To see
what it did, run git-diff to be sure that the changes are expected and look
sane.  If the change looks sane, commit the file and push the changes to
Github.

To make the changes live, go to your clone of the *mlabops* repository and do:

```
# cd mlabops/ansible/dns
# ansible-playbook deploy_zone.yaml
```
