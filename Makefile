TEMPLATE_PATH="packer/templates/debian.json"
TEMPLATE1_PATH="packer/templates/debian1.json"
TEMPLATE2_PATH="packer/templates/debian2.json"
TEMPLATE3_PATH="packer/templates/debian3.json"
TEMPLATE4_PATH="packer/templates/debian4.json"
LOG_PATH="packer/logs/packer_output_S0.txt"
LOG_PATH="packer/logs/packer_output_S1.txt"
LOG2_PATH="packer/logs/packer_output_S2.txt"
LOG3_PATH="packer/logs/packer_output_S3.txt"
LOG4_PATH="packer/logs/packer_output_S4.txt"

run: export build

export:
	. export.sh
build:
	packer build $(TEMPLATE_PATH) | tee $(LOG_PATH)
	packer build $(TEMPLATE2_PATH) | tee $(LOG2_PATH)
	packer build $(TEMPLATE3_PATH) | tee $(LOG3_PATH)
	packer build $(TEMPLATE4_PATH) | tee $(LOG4_PATH)
