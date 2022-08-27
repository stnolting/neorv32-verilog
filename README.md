# NEORV32 in Verilog

[![neorv32-verilog](https://img.shields.io/github/workflow/status/stnolting/neorv32-verilog/Verification/main?longCache=true&style=flat-square&label=Processor&logo=Github%20Actions&logoColor=fff)](https://github.com/stnolting/neorv32-verilog/actions/workflows/main.yml)
[![License](https://img.shields.io/github/license/stnolting/neorv32-verilog?longCache=true&style=flat-square&label=License)](https://github.com/stnolting/neorv32-verilog/blob/main/LICENSE)
[![Gitter](https://img.shields.io/badge/Chat-on%20gitter-4db797.svg?longCache=true&style=flat-square&logo=gitter&logoColor=e8ecef)](https://gitter.im/neorv32/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

* [Prerequisites](#Prerequisites)
* [Configuration](#Configuration)
* [Conversion](#Conversion)
* [Simulation](#Simulation)

This repository shows how to convert the [NEORV32 RISC-V Processor](https://github.com/stnolting/neorv32), which is
written in platform-independent **VHDL**, into a plain and synthesizable **Verilog** netlist using
[GHDL's](https://github.com/ghdl/ghdl) synthesis feature.

The resulting Verilog module can be instantiated within pure Verilog design and can be successfully simulated
synthesized (tested with Icarus Verilog) and synthesized (tested with Xilinx Vivado).


### Prerequisites

1. Clone this repository recursively to include the NEORV32 submodule.

2. Install GHDL. On a Linux machine GHDL can be easily installed via the package manager.
Make sure GHDL's `--synth` option is enabled (should be enabled by default).

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


### Configuration

**:construction: work in progress :construction:**

[[back to top](#NEORV32-in-Verilog)]


### Conversion

**:construction: work in progress :construction:**

[[back to top](#NEORV32-in-Verilog)]


### Simulation

**:construction: work in progress :construction:**

[[back to top](#NEORV32-in-Verilog)]

