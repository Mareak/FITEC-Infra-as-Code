TEMPLATE_PATH0="packer/templates/debian.json"
TEMPLATE_PATH1="packer/templates/debian1.json"
TEMPLATE2_PATH2="packer/templates/debian2.json"
TEMPLATE3_PATH3="packer/templates/debian3.json"
TEMPLATE4_PATH4="packer/templates/debian4.json"

run: export build

export:
	. export.sh
build:
	packer build ${TEMPLATE_PATH0}
	packer build ${TEMPLATE_PATH1}
	packer build ${TEMPLATE_PATH2}
	packer build ${TEMPLATE_PATH3}
	packer build ${TEMPLATE_PATH4}
     
