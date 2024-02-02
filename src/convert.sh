#!/usr/bin/env bash

set -e

cd $(dirname "$0")

NEORV32_RTL=${NEORV32_RTL:-../neorv32/rtl}
SRC_FOLDER=${SRC_FOLDER:-.}

mkdir -p build

# show NEORV32 version
echo "NEORV32 Version:"
grep -rni "$NEORV32_RTL"/core/neorv32_package.vhd -e 'hw_version_c'
echo ""
sleep 2

# Import sources
ghdl -i --std=08 --work=neorv32 --workdir=build -Pbuild \
  "$NEORV32_RTL"/core/*.vhd \
  "$NEORV32_RTL"/core/mem/*.vhd \
  "$SRC_FOLDER"/neorv32_verilog_wrapper.vhd

# Top entity
ghdl -m --std=08 --work=neorv32 --workdir=build neorv32_verilog_wrapper

# Synthesize: generate Verilog output
ghdl synth --std=08 --work=neorv32 --workdir=build -Pbuild --out=verilog neorv32_verilog_wrapper > "$SRC_FOLDER"/neorv32_verilog_wrapper.v

# Show interface of generated Verilog module
echo ""
echo "------ neorv32_verilog_wrapper interface ------"
sed -n "/module neorv32_verilog_wrapper/,/);/p" "$SRC_FOLDER"/neorv32_verilog_wrapper.v
echo "-----------------------------------------------"
echo ""
