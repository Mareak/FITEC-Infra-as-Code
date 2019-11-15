TEMPLATE_PATH="packer/templates/debian.json"
LOG_PATH="packer/logs/packer_output.txt"

run: export build

export:
	. export.sh
build:
	packer build $(TEMPLATE_PATH) | tee $(LOG_PATH)

