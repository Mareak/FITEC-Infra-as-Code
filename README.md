# mareak-fitec-P1

A project on the infrastucture as code based on PACKER, ANSIBLE, TERRRAFORM and AZURE CLOUD.

This infrastructure is composed of multiple things:

- 5 vms (S0, S1, S2, S3, S4).
- S0 : dnsmask(Dns), haproxy(Reverse proxy).
- S1, S2 : wordpress(Website).
- S3 : mariadb(Database).
- S4 : NFS server(Nfs).

The script also use Azure file shares (premium type for speed access) to mount the web files on both website servers.

* How it Works :

1. Add your own credentials to connect to azure.
2. Use terraform and deploy your infrastructure.
