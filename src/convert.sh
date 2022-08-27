#!/usr/bin/env bash

set -e

cd $(dirname "$0")

NEORV32_RTL=${NEORV32_RTL:-../neorv32/rtl}
SRC_FOLDER=${SRC_FOLDER:-.}

mkdir -p build

# Processor core files - package and images
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_package.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_application_image.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_bootloader_image.vhd

# Processor core files
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_boot_rom.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_bus_keeper.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_busswitch.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_cfs.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_cpu.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_cpu_alu.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_cpu_bus.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_cpu_control.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_cpu_cp_bitmanip.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_cpu_cp_cfu.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_cpu_cp_fpu.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_cpu_cp_muldiv.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_cpu_cp_shifter.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_cpu_decompressor.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_cpu_regfile.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_debug_dm.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_debug_dtm.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_dmem.entity.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_fifo.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_gpio.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_gptmr.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_icache.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_imem.entity.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_mtime.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_neoled.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_pwm.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_slink.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_spi.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_sysinfo.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_top.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_trng.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_twi.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_uart.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_wdt.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_wishbone.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_xip.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/neorv32_xirq.vhd

# Default (generic) processor-internal memories
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/mem/neorv32_dmem.default.vhd
ghdl -a --work=neorv32 --workdir=build -Pbuild "$NEORV32_RTL"/core/mem/neorv32_imem.default.vhd

# Top wrapper
ghdl -a --work=neorv32 --workdir=build -Pbuild "$SRC_FOLDER"/neorv32_verilog_wrapper.vhd

# Synthesize: generate Verilog output
ghdl synth --work=neorv32 --workdir=build -Pbuild --out=verilog neorv32_verilog_wrapper > "$SRC_FOLDER"/neorv32_verilog_wrapper.v

# Show interface of generated Verilog module
echo ""
echo "------ neorv32_verilog_wrapper interface ------"
sed -n "/module neorv32_verilog_wrapper/,/);/p" "$SRC_FOLDER"/neorv32_verilog_wrapper.v
echo ""
