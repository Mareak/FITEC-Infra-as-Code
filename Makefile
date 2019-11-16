TEMPLATE_PATH="packer/templates/debian.json"
TEMPLATE2_PATH="packer/templates/debian2.json"
LOG_PATH="packer/logs/packer_output_S1.txt"
LOG2_PATH="packer/logs/packer_output_S2.txt"

run: export build

export:
	. export.sh
build:
	packer build $(TEMPLATE_PATH) | tee $(LOG_PATH)
	packer build $(TEMPLATE2_PATH) | tee $(LOG2_PATH)
