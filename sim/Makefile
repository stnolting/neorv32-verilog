.PHONY: run clean

all: run

SIM ?= icarus
SRC_FOLDER ?= ../src
SIM_FOLDER ?= .

SRC_FILES = $(SIM_FOLDER)/testbench.v $(SIM_FOLDER)/uart_sim_receiver.v $(SRC_FOLDER)/neorv32_verilog_wrapper.v
VERILATOR_ARGS = -Wno-fatal --binary --trace

__run_icarus:
	iverilog -o neorv32-verilog-sim $(SRC_FILES)
	vvp neorv32-verilog-sim

__run_verilator:
	verilator $(VERILATOR_ARGS) $(SRC_FILES)
	./obj_dir/Vtestbench

run:
	@echo "Running simulation with $(SIM)"
ifeq ($(SIM), icarus)
	$(MAKE) __run_icarus
else ifeq ($(SIM), verilator)
	$(MAKE) __run_verilator
else
	$(error Unsupported simulator: $(SIM))
endif

clean:
	@rm -rf ./neorv32-verilog-sim obj_dir
