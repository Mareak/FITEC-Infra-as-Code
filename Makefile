TEMPLATE0_PATH="packer/templates/debian.json"
TEMPLATE1_PATH="packer/templates/debian1.json"
TEMPLATE2_PATH="packer/templates/debian2.json"
TEMPLATE3_PATH="packer/templates/debian3.json"
TEMPLATE4_PATH="packer/templates/debian4.json"
LOG0_PATH="packer/logs/packer_output_S0.txt"
LOG1_PATH="packer/logs/packer_output_S1.txt"
LOG2_PATH="packer/logs/packer_output_S2.txt"
LOG3_PATH="packer/logs/packer_output_S3.txt"
LOG4_PATH="packer/logs/packer_output_S4.txt"

run: export build

export:
	. export.sh
build:
	for i in {0..4};do packer build $(TEMPLATE{$i}_PATH) | tee $(LOG{$i}_PATH);done;
