#!/usr/bin/env bash

set -e

cd $(dirname "$0")

SRC_FOLDER=${SRC_FOLDER:-../src}
SIM_FOLDER=${SIM_FOLDER:-.}

iverilog -o "$SIM_FOLDER"/neorv32-verilog-sim "$SIM_FOLDER"/testbench.v "$SIM_FOLDER"/uart_sim_receiver.v "$SRC_FOLDER"/neorv32_verilog_wrapper.v
vvp "$SIM_FOLDER"/neorv32-verilog-sim
