#!/usr/bin/env bash

set -e

cd $(dirname "$0")

RTL_FOLDER=${RTL_FOLDER:-../neorv32/rtl}
SRC_FOLDER=${SRC_FOLDER:-../src}
SIM_FOLDER=${SIM_FOLDER:-../sim}

echo ">> neorv32-verilog verification script"

echo ">> Checking NEORV32 version..."
grep -rni "$RTL_FOLDER"/core/neorv32_package.vhd -e 'hw_version_c'

echo ">> Generating Verilog..."
sh "$SRC_FOLDER"/convert.sh

echo ">> Running simulation..."
touch sim_log
sh "$SIM_FOLDER"/iverilog_sim.sh > sim_log

echo ">> Checking simulation result..."
cat sim_log
grep 'Simulation successful!' sim_log
