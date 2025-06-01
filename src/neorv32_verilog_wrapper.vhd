-- ================================================================================ --
-- NEORV32 Wrapper for Verilog Conversion                                           --
-- -------------------------------------------------------------------------------- --
-- The NEORV32 RISC-V Processor - https://github.com/stnolting/neorv32              --
-- Copyright (c) NEORV32 contributors.                                              --
-- Copyright (c) 2020 - 2025 Stephan Nolting. All rights reserved.                  --
-- Licensed under the BSD-3-Clause license, see LICENSE for details.                --
-- SPDX-License-Identifier: BSD-3-Clause                                            --
-- ================================================================================ --

library ieee;
use ieee.std_logic_1164.all;

library neorv32;
use neorv32.neorv32_package.all;

entity neorv32_verilog_wrapper is
  port ( -- [note] add ports as required; generics cannot be used
    -- Global control --
    clk_i       : in  std_ulogic; -- global clock, rising edge
    rstn_i      : in  std_ulogic; -- global reset, low-active, async
    -- UART0 --
    uart0_txd_o : out std_ulogic; -- UART0 send data
    uart0_rxd_i : in  std_ulogic  -- UART0 receive data
  );
end entity;

architecture neorv32_verilog_wrapper_rtl of neorv32_verilog_wrapper is

begin

  -- The core of the problem ----------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  neorv32_top_inst: neorv32_top
  generic map ( -- [note] add configuration options as required
    -- Processor Clocking --
    CLOCK_FREQUENCY     => 100_000_000, -- clock frequency of clk_i in Hz
    -- Boot Configuration --
    BOOT_MODE_SELECT    => 0,           -- boot via internal bootloader
    -- On-Chip Debugger (OCD) --
    OCD_EN              => true,        -- implement on-chip debugger
    OCD_AUTHENTICATION  => true,        -- implement on-chip debugger authentication
    -- RISC-V CPU Extensions --
    RISCV_ISA_C         => true,        -- implement compressed extension
    RISCV_ISA_M         => true,        -- implement mul/div extension
    RISCV_ISA_U         => true,        -- implement user mode extension
    RISCV_ISA_Zaamo     => true,        -- implement atomic memory operations extension
    RISCV_ISA_Zba       => true,        -- implement shifted-add bit-manipulation extension
    RISCV_ISA_Zbb       => true,        -- implement basic bit-manipulation extension
    RISCV_ISA_Zbkb      => true,        -- implement bit-manipulation instructions for cryptography
    RISCV_ISA_Zbkc      => true,        -- implement carry-less multiplication instructions
    RISCV_ISA_Zbkx      => true,        -- implement cryptography crossbar permutation extension
    RISCV_ISA_Zbs       => true,        -- implement single-bit bit-manipulation extension
    RISCV_ISA_Zfinx     => true,        -- implement 32-bit floating-point extension
    RISCV_ISA_Zicntr    => true,        -- implement base counters
    RISCV_ISA_Zicond    => true,        -- implement integer conditional operations
    RISCV_ISA_Zihpm     => true,        -- implement hardware performance monitors
    RISCV_ISA_Zknd      => true,        -- implement cryptography NIST AES decryption extension
    RISCV_ISA_Zkne      => true,        -- implement cryptography NIST AES encryption extension
    RISCV_ISA_Zknh      => true,        -- implement cryptography NIST hash extension
    RISCV_ISA_Zksed     => true,        -- implement ShangMi block cipher extension
    RISCV_ISA_Zksh      => true,        -- implement ShangMi hash extension
    RISCV_ISA_Zxcfu     => true,        -- implement custom (instr.) functions unit
    -- Tuning Options --
    CPU_FAST_MUL_EN     => true,        -- use DSPs for M extension's multiplier
    CPU_FAST_SHIFT_EN   => true,        -- use barrel shifter for shift operations
    -- Physical Memory Protection (PMP) --
    PMP_NUM_REGIONS     => 4,           -- number of regions (0..16)
    PMP_MIN_GRANULARITY => 4,           -- minimal region granularity in bytes, has to be a power of 2, min 4 bytes
    PMP_TOR_MODE_EN     => true,        -- implement TOR mode
    PMP_NAP_MODE_EN     => true,        -- implement NAPOT/NA4 modes
    -- Hardware Performance Monitors (HPM) --
    HPM_NUM_CNTS        => 6,           -- number of implemented HPM counters (0..13)
    HPM_CNT_WIDTH       => 40,          -- total size of HPM counters (0..64)
    -- Internal Instruction memory (IMEM) --
    IMEM_EN             => true,        -- implement processor-internal instruction memory
    IMEM_SIZE           => 16*1024,     -- size of processor-internal instruction memory in bytes
    -- Internal Data memory (DMEM) --
    DMEM_EN             => true,        -- implement processor-internal data memory
    DMEM_SIZE           => 8*1024,      -- size of processor-internal data memory in bytes
    -- CPU Caches --
    ICACHE_EN           => true,        -- implement instruction cache (i-cache)
    ICACHE_NUM_BLOCKS   => 4,           -- i-cache: number of blocks (min 1), has to be a power of 2
    DCACHE_EN           => true,        -- implement data cache (d-cache)
    DCACHE_NUM_BLOCKS   => 4,           -- d-cache: number of blocks (min 1), has to be a power of 2
    CACHE_BLOCK_SIZE    => 64,          -- i-cache/d-cache: block size in bytes (min 4), has to be a power of 2
    -- External bus interface (XBUS) --
    XBUS_EN             => true,        -- implement external memory bus interface?
    XBUS_TIMEOUT        => 256,         -- cycles after a pending bus access auto-terminates (0 = disabled)
    XBUS_REGSTAGE_EN    => true,        -- add XBUS register stage
    -- Processor peripherals --
    IO_CLINT_EN         => true,        -- implement core local interruptor (CLINT)?
    IO_UART0_EN         => true,        -- implement primary universal asynchronous receiver/transmitter (UART0)?
    IO_UART0_RX_FIFO    => 64,          -- RX FIFO depth, has to be a power of two, min 1
    IO_UART0_TX_FIFO    => 64,          -- TX FIFO depth, has to be a power of two, min 1
    IO_SPI_EN           => true,        -- implement serial peripheral interface (SPI)?
    IO_TWI_EN           => true,        -- implement two-wire interface (TWI)?
    IO_TWD_EN           => true,        -- implement two-wire device (TWD)?
    IO_PWM_NUM_CH       => 2,           -- number of PWM channels to implement (0..16)
    IO_WDT_EN           => true,        -- implement watch dog timer (WDT)?
    IO_NEOLED_EN        => true,        -- implement NeoPixel-compatible smart LED interface (NEOLED)?
    IO_GPTMR_EN         => true,        -- implement general purpose timer (GPTMR)?
    IO_ONEWIRE_EN       => true,        -- implement 1-wire interface (ONEWIRE)?
    IO_DMA_EN           => true,        -- implement direct memory access controller (DMA)?
    IO_SLINK_EN         => true         -- implement stream link interface (SLINK)?
  )
  port map ( -- [note] add ports as required
    -- Global control --
    clk_i       => clk_i,       -- global clock, rising edge
    rstn_i      => rstn_i,      -- global reset, low-active, async
    -- primary UART0 (available if IO_UART0_EN = true) --
    uart0_txd_o => uart0_txd_o, -- UART0 send data
    uart0_rxd_i => uart0_rxd_i  -- UART0 receive data
  );

end architecture;
