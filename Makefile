.DEFAULT_GOAL := help
all: check clean convert run

SIMULATOR ?= iverilog
SRC_FOLDER ?= src
SIM_FOLDER ?= sim
NEORV32_VERILOG = $(SRC_FOLDER)/neorv32_verilog_wrapper.v

SRC_FILES = $(SIM_FOLDER)/testbench.v $(SIM_FOLDER)/uart_sim_receiver.v $(NEORV32_VERILOG)
VERILATOR_ARGS = -Wno-fatal --binary --trace

check:
	@ghdl -v

convert: $(NEORV32_VERILOG)

$(NEORV32_VERILOG):
	@echo "Converting to Verilog..."
	@sh $(SRC_FOLDER)/convert.sh

sim: $(NEORV32_VERILOG)
	@echo "Running simulation with $(SIMULATOR)"
ifeq ($(SIMULATOR), iverilog)
	iverilog -o neorv32-verilog-sim $(SRC_FILES)
	vvp neorv32-verilog-sim
else ifeq ($(SIMULATOR), verilator)
	verilator $(VERILATOR_ARGS) $(SRC_FILES)
	./obj_dir/Vtestbench
else
	$(error Unsupported simulator: $(SIMULATOR))
endif

clean:
	@echo "Removing artifacts..."
	rm -rf $(SRC_FOLDER)/build
	rm -rf $(SRC_FOLDER)/neorv32_verilog_wrapper.v
	rm -rf $(SIM_FOLDER)/neorv32-verilog-sim
	rm -rf $(SIM_FOLDER)/obj_dir

help:
	@echo "neorv32-verilog makefile"
	@echo ""
	@echo "Targets:"
	@echo "  help     Show this text"
	@echo "  check    Show GHDL version"
	@echo "  convert  Convert NEORV32 to Verilog (generate '$(NEORV32_VERILOG)')"
	@echo "  sim      Run simulation with Icarus Verilog or Verilator"
	@echo "  clean    Remove all artifacts"
	@echo "  all      check + clean + convert + sim"
	@echo ""
	@echo "Variables:"
	@echo "  SIMULATOR  Verilog simulator, 'iverilog' or 'verilator'; default = $(SIMULATOR)"
	@echo ""
	@echo "Example:"
	@echo "  make SIMULATOR=iverilog clean convert sim"