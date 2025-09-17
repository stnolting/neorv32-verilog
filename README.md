# NEORV32 _in_ Verilog

[![neorv32-verilog](https://img.shields.io/github/actions/workflow/status/stnolting/neorv32-verilog/main.yml?branch=main&longCache=true&style=flat-square&label=neorv32-verilog%20check&logo=Github%20Actions&logoColor=fff)](https://github.com/stnolting/neorv32-verilog/actions/workflows/main.yml)
[![License](https://img.shields.io/github/license/stnolting/neorv32-verilog?longCache=true&style=flat-square&label=License)](https://github.com/stnolting/neorv32-verilog/blob/main/LICENSE)

1. [Prerequisites](#prerequisites)
2. [Configuration](#configuration)
3. [Conversion](#conversion)
4. [Simulation](#simulation)
5. [Evaluation](#evaluation)

This repository shows how to convert a complex **VHDL** design into a single, synthesizable, **plain-Verilog module** using
[GHDL's](https://github.com/ghdl/ghdl) synthesis feature. The example in this repository is based on the
[NEORV32 RISC-V Processor](https://github.com/stnolting/neorv32), which is written in _platform-independent_ VHDL.
The resulting Verilog module can be instantiated within an all-Verilog design and can be successfully simulated and
synthesized - tested with Xilinx Vivado and Intel Quartus (see section [Evaluation](#evaluation)).

Detailed information regarding GHDL's synthesis feature can be found in the
[GHDL synthesis documentation](https://ghdl.github.io/ghdl/using/Synthesis.html).

> [!NOTE]
> The [verification workflow](https://github.com/stnolting/neorv32-verilog/actions/workflows/main.yml)
converts a pre-configured setup of the latest NEORV32 version to Verilog and tests the result by running
an [Icarus Verilog](https://github.com/steveicarus/iverilog) simulation.
The generated Verilog code for the default processor configuration can be downloaded as
[CI Workflow artifact](https://github.com/stnolting/neorv32-verilog/actions).


## Prerequisites

1. Clone this repository **recursively** to include the NEORV32 submodule.

2. Install GHDL. On a Linux machine GHDL can be installed easily via the package manager.
:warning: **Make sure to install a version with `--synth` option enabled (should be enabled by default).
GHDL version 3.0.0 or higher is required.**

```
$ sudo apt-get install ghdl
```

3. Test the GHDL installation and check the version.

```
neorv32-verilog$ make check
GHDL 4.1.0 (4.0.0.r39.g7188e92cf) [Dunoon edition]
 Compiled with GNAT Version: 10.5.0
 static elaboration, mcode JIT code generator
Written by Tristan Gingold.

Copyright (C) 2003 - 2024 Tristan Gingold.
GHDL is free software, covered by the GNU General Public License.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```


## Configuration

GHDL's `synth` option is used to convert the whole NEORV32 processor - including all peripherals, memories
and memory images - into a single plain-Verilog module file.

> [!WARNING]
> The output of the GHDL synthesis is a _post-elaboration_ result. Therefore, all the processor's configuration
options (i.e. VHDL generics) are resolved _before_ the actual output is generated (see the GHDL
[internals documentation](http://ghdl.github.io/ghdl/internals/index.html)).

To ease configuration and customization a minimal VHDL wrapper
[`src/neorv32_verilog_wrapper.vhd`](https://github.com/stnolting/neorv32-verilog/blob/main/src/neorv32_verilog_wrapper.vhd)
is provided. This wrapper can be used to configure the processor setup according to the requirements.
The default wrapper from this repository only implements a minimal subset of the available configuration options
and interfaces - just enough to run the processor's built-in bootloader.

Have a look at the original [processor top entity (`neorv32_top.vhd`)](https://github.com/stnolting/neorv32/blob/main/rtl/core/neorv32_top.vhd)
and just copy the generics and ports that you would like to use for the Verilog setup.
Note that all NEORV32 interface inputs and configuration generics do provide _default values_.


## Conversion

The actual conversion is conducted by a conversion shell script, which analyzes all the processor's sources and finally
calls GHDL `synth` to create the final Verilog code `neorv32-verilog/src/neorv32_verilog_wrapper.v`. The conversion script
is invoked by the Makefile:

```bash
neorv32-verilog$ make convert
```

After conversion, the interface of the resulting `neorv32_verilog_wrapper` Verilog
module is shown in the console. This can be used as instantiation template.

```
------ neorv32_verilog_wrapper interface ------
module neorv32_verilog_wrapper
  (input  clk_i,
   input  rstn_i,
   input  uart0_rxd_i,
   output uart0_txd_o);
-----------------------------------------------
```

### Notes

* GHDL synthesis generates an unoptimized plain Verilog code without any (technology-specific) primitives.
However, optimizations will be performed by the synthesis tool (e.g. mapping to FPGA primitives like block RAMs).
* The interface of the resulting NEORV32 Verilog module lists all inputs first followed by all outputs.
* The original NEORV32 module hierarchy is preserved as well as most (all?) signal names, which allows easy inspection and debugging
of simulation waveforms and synthesis results.
* Custom VHDL interface types and records are collapsed into linear arrays.


## Simulation

This repository provides a simple [Verilog testbench](https://github.com/stnolting/neorv32-verilog/blob/main/sim/testbench.v)
that can be used to simulate converted NEORV32 processor. The testbench includes a UART receiver, which is driven by the
processor's UART0. The receiver outputs received characters to the simulator console.

You can use [Icarus Verilog](https://github.com/steveicarus/iverilog) or
[Verilator](https://github.com/verilator/verilator) for simulation:

* Icarus Verilog: `neorv32-verilog$ make SIMULATOR=iverilog sim`
* Verilator: `neorv32-verilog$ make SIMULATOR=verilator sim`

Example:

```bash
neorv32-verilog$ make SIMULATOR=iverilog sim
Running simulation with Icarus Verilog
iverilog -o neorv32-verilog-sim sim/testbench.v sim/uart_sim_receiver.v src/neorv32_verilog_wrapper.v
vvp neorv32-verilog-sim
neorv32-verilog verification testbench




NEORV32
Simulation successful!
```

The simulation is terminated automatically as soon as the string "`NEORV32`" has been received from the processor's bootloader.
In this case `Simulation successful!` is printed to the console. If `Simulation terminated!` appears in the simulator console
the simulation has failed.


### Dumping Waveform Data

The simulator (Icarus Verilog or Verilator) will emit waveform data if the `DUMP_WAVE` variable is set to `1`. Example:

```bash
neorv32-verilog$ make SIMULATOR=verilator DUMP_WAVE=1 sim
```

The waveform dump file will be stored as `wave.fst` in the repository's root directory.
It can be viewed with GTKwave, for example:

```bash
neorv32-verilog$ gtkwave wave.fst
```

> [!NOTE]
> Dumping waveform data with Icarus Verilog for the _default_ testbench and processor configuration
> will take quite some time.


## Evaluation

It's time for a "quality" evaluation of the auto-generated Verilog. Therefore,
two projects were created: a pure Verilog one using the auto-generated `src/neorv32_verilog_wrapper.v` file and a
pure VHDL one using the provided `src/neorv32_verilog_wrapper.vhd` file. For both projects a simple top entity was
created (again, a Verilog and a VHDL version) that instantiate the according `neorv32_verilog_wrapper` module
together with a PLL for providing clock (100MHz) and reset.

The default configuration of the wrapper was used:

* Memories: 16kB IMEM (RAM), 8kB DMEM (RAM), 4kB internal bootloader ROM
* CPU: `rv32imc_Zicsr_Zicntr_Zifencei`
* Peripherals: UART0, GPIO, MTIME

Both setups were synthesized for an Intel Cyclone IV E FPGA (EP4CE22F17C6) using Intel Quartus Prime 21.1.0
with default settings ("balanced" implementation). The timing analyzer's "Slow 1200mV 0C Model" was used to
evaluate the maximum operating frequency f_max. Additionally, both setups were (successfully! :tada:) tested
on a Terasic DE0-nano FPGA board.

| NEORV32 [v1.7.6.0](https://github.com/stnolting/neorv32/blob/main/CHANGELOG.md) | All-Verilog | All-VHDL |
|:---------------------|:-----------:|:--------:|
| Total logic elements | 3697        | 3287     |
| Total registers      | 1436        | 1450     |
| Total pins           | 4           | 4        |
| Total memory bits    | 230400      | 230400   |
| Embedded multiplier  | 0           | 0        |
| f_max [MHz]          | 115.3       | 122.2    |
| Operational          | yes         | yes      |
