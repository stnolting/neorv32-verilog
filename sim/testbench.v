// simple testbench to check the default NEORV32 Verilog wrapper
// checks for the initial UARt output of the bootloader: "NEORV32"

// by Stephan Nolting, BSD 3-Clause License
// https://github.com/stnolting/neorv32-verilog

`timescale 1 ns/100 ps  // time-unit = 1 ns, precision = 100 ps

module neorv32_verilog_tb;

  reg clk, nrst; // generators
  wire uart_txd;
  wire [7:0] char_data;
  wire char_valid;

  // generator setup
  initial begin
    $display ("neorv32-verilog testbench\n");
    clk = 0;
    nrst = 0;
    #50; // active reset for 50 * timescale = 50 ns
    nrst = 1;
    #10_000_000;
    // if we reach this the simulation has failed
    $display("Simulation terminated!");
    $finish; // terminate
  end

  // clock generator
  always begin
    #5 clk = !clk; // 100 MHz
  end

  // unit under test: NEORV32 Verilog wrapper
  neorv32_verilog_wrapper uut(
  .clk_i(clk),
  .rstn_i(nrst),
  .uart0_rxd_i(1'b0),
  .uart0_txd_o(uart_txd)
 );

  // simulation UART receiver
  uart_sim_receiver #(
    .BAUD_RATE(19200),
    .CLOCK_FREQ(100000000)
  )
  uart_receiver(
    .clk_i(clk),
    .txd_i(uart_txd),
    .data_o(char_data),
    .valid_o(char_valid)
  );

  // buffer the processor's UART data in a small FIFO
  reg [7:0] char_buffer [0:6];
  integer i;

  always @(posedge clk) begin
    // update "FIFO"
    if (char_valid) begin
      for (i=6; i>0; i=i-1) begin
        char_buffer[i-1] <= char_buffer[i];
      end
      char_buffer[6] <= char_data;
    end
    // check for result string: "NEORV32" is sent by the default bootloader
    // right after reset
    if ((char_buffer[0] == "N") &&
        (char_buffer[1] == "E") &&
        (char_buffer[2] == "O") &&
        (char_buffer[3] == "R") &&
        (char_buffer[4] == "V") &&
        (char_buffer[5] == "3") &&
        (char_buffer[6] == "2")) begin
      // simulation was successful
      $display (""); // line break
      $display("Simulation successful!");
      $finish; // terminate
    end
  end

endmodule
