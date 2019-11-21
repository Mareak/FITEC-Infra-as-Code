#!/bin/bash
storage="mareakp1storageacc.file.core.windows.net/mareak-p1-share"
username="mareakp1storageacc"
password="XGkSBVz5Yf2YDrUexMVi5lWR5cOxmeI+GGsm0PwOsde2cxJ+5vinpRk38Cs4c4QBHA7oFx2aeBacbVO346VFhQ=="

echo "//${storage} /var/www/html cifs _netdev,nofail,vers=3.0,username=${username},password=${password},dir_mode=0755,file_mode=0755,serverino" >> /etc/fstab
