library ieee;
use ieee.std_logic_1164.all;

library neorv32;
use neorv32.neorv32_package.all;

entity neorv32_verilog_wrapper is
  port ( -- ADD PORTS AS REQUIRED
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
  generic map ( -- ADD CONFIGURATION OPTIONS AS REQUIRED
    -- General --
    CLOCK_FREQUENCY            => 100_000_000, -- clock frequency of clk_i in Hz
    INT_BOOTLOADER_EN          => true,        -- boot configuration: boot explicit bootloader
    -- RISC-V CPU Extensions --
    CPU_EXTENSION_RISCV_A      => true,        -- implement atomic memory operations extension?
    CPU_EXTENSION_RISCV_C      => true,        -- implement compressed extension?
    CPU_EXTENSION_RISCV_M      => true,        -- implement mul/div extension?
    CPU_EXTENSION_RISCV_U      => true,        -- implement user mode extension?
    CPU_EXTENSION_RISCV_Zfinx  => true,        -- implement 32-bit floating-point extension (using INT regs!)
    CPU_EXTENSION_RISCV_Zicntr => true,        -- implement base counters?
    CPU_EXTENSION_RISCV_Zicond => true,        -- implement integer conditional operations?
    CPU_EXTENSION_RISCV_Zihpm  => true,        -- implement hardware performance monitors?
    -- Tuning Options --
    FAST_MUL_EN                => true,        -- use DSPs for M extension's multiplier
    FAST_SHIFT_EN              => true,        -- use barrel shifter for shift operations
    -- Physical Memory Protection (PMP) --
    PMP_NUM_REGIONS            => 4,           -- number of regions (0..16)
    PMP_MIN_GRANULARITY        => 4,           -- minimal region granularity in bytes, has to be a power of 2, min 4 bytes
    -- Hardware Performance Monitors (HPM) --
    HPM_NUM_CNTS               => 10,          -- number of implemented HPM counters (0..13)
    HPM_CNT_WIDTH              => 40,          -- total size of HPM counters (0..64)
    -- Atomic Memory Access - Reservation Set Granularity --
    AMO_RVS_GRANULARITY        => 4,           -- size in bytes, has to be a power of 2, min 4
    -- Internal Instruction memory (IMEM) --
    MEM_INT_IMEM_EN            => true,        -- implement processor-internal instruction memory
    MEM_INT_IMEM_SIZE          => 16*1024,     -- size of processor-internal instruction memory in bytes
    -- Internal Data memory (DMEM) --
    MEM_INT_DMEM_EN            => true,        -- implement processor-internal data memory
    MEM_INT_DMEM_SIZE          => 8*1024,      -- size of processor-internal data memory in bytes
    -- Processor peripherals --
    IO_MTIME_EN                => true,        -- implement machine system timer (MTIME)?
    IO_UART0_EN                => true,        -- implement primary universal asynchronous receiver/transmitter (UART0)?
    IO_UART0_RX_FIFO           => 64,          -- RX fifo depth, has to be a power of two, min 1
    IO_UART0_TX_FIFO           => 64           -- TX fifo depth, has to be a power of two, min 1
  )
  port map ( -- ADD PORTS AS REQUIRED
    -- Global control --
    clk_i       => clk_i,       -- global clock, rising edge
    rstn_i      => rstn_i,      -- global reset, low-active, async
    -- primary UART0 (available if IO_UART0_EN = true) --
    uart0_txd_o => uart0_txd_o, -- UART0 send data
    uart0_rxd_i => uart0_rxd_i  -- UART0 receive data
  );

end architecture;
