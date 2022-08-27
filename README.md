# NEORV32 "in" Verilog

[![neorv32-verilog](https://img.shields.io/github/workflow/status/stnolting/neorv32-verilog/Verification/main?longCache=true&style=flat-square&label=neorv32-verilog%20check&logo=Github%20Actions&logoColor=fff)](https://github.com/stnolting/neorv32-verilog/actions/workflows/main.yml)
[![License](https://img.shields.io/github/license/stnolting/neorv32-verilog?longCache=true&style=flat-square&label=License)](https://github.com/stnolting/neorv32-verilog/blob/main/LICENSE)
[![Gitter](https://img.shields.io/badge/Chat-on%20gitter-4db797.svg?longCache=true&style=flat-square&logo=gitter&logoColor=e8ecef)](https://gitter.im/neorv32/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

1. [Prerequisites](#Prerequisites)
2. [Configuration and Conversion](#Configuration-and-Conversion)
3. [Simulation](#Simulation)

This repository shows how to convert the [NEORV32 RISC-V Processor](https://github.com/stnolting/neorv32), which is
written in platform-independent **VHDL**, into a plain and synthesizable **Verilog** netlist using
[GHDL's](https://github.com/ghdl/ghdl) synthesis feature. The resulting Verilog module can be instantiated within an
all-Verilog designs and can be simulated and synthesized - tested with Xilinx Vivado.

:heavy_check_mark: The [verification workflow]https://github.com/stnolting/neorv32-verilog/actions/workflows/main.yml)
converts a pre-configured setup of latest processor version into a Verilog netlist and tests the result by running
an [Icarus Verilog](https://github.com/steveicarus/iverilog) simulation.


## Prerequisites

1. Clone this repository recursively to include the NEORV32 submodule.

2. Install GHDL. On a Linux machine GHDL can be easily installed via the package manager.
Make sure to install a version with `--synth` option enabled (should be enabled by default).

```bash
$ sudo apt-get install ghdl
```

3. Check the GHDL installation:

```bash
$ ghdl -v
GHDL 3.0.0-dev (v2.0.0-652-g6961b3f82) [Dunoon edition]
 Compiled with GNAT Version: 9.4.0
 mcode code generator
Written by Tristan Gingold.

Copyright (C) 2003 - 2022 Tristan Gingold.
GHDL is free software, covered by the GNU General Public License.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

4. Detailed information regarding GHDL's synthesis feature can be in the documentation:
[https://ghdl.github.io/ghdl/using/Synthesis.html](https://ghdl.github.io/ghdl/using/Synthesis.html)

[[back to top](#NEORV32-in-Verilog)]


## Configuration and Conversion

**:construction: under construction :construction:

[[back to top](#NEORV32-in-Verilog)]


## Simulation

This repository provides a simple [Verilog testbench](https://github.com/stnolting/neorv32-verilog/blob/main/sim/testbench.v)
that can be used to simulate the default NEORV32 configuration. The testbench includes a UART receiver, which is driven by the
processor UART0. It outputs received characters to the simulator console.

A pre-configured [simulation script](https://github.com/stnolting/neorv32-verilog/blob/main/sim/iverilog_sim.sh)
that is based on [Icarus Verilog](https://github.com/steveicarus/iverilog) can be used to simulate the Verilog setup
(takes several minutes to complete):

```bash
neorv32-verilog/sim$ sh iverilog_sim.sh

```

The simulation is terminated automatically as soon as the string "`NEORV32`" has been received from the processor's bootloader.

:bulb: Prebuilt Icarus Verilog binaries for Linux can be downloaded from
[github.com/stnolting/icarus-verilog-prebuilt](https://github.com/stnolting/icarus-verilog-prebuilt).
[![Check_iverilog](https://img.shields.io/github/workflow/status/stnolting/icarus-verilog-prebuilt/Check%20Icarus%20Verilog%20Packages/main?longCache=true&style=flat&label=Check%20iverilog&logo=Github%20Actions&logoColor=fff)](https://github.com/stnolting/icarus-verilog-prebuilt/actions/workflows/check_iverilog.yml)

[[back to top](#NEORV32-in-Verilog)]
