`default_nettype none
`timescale 1ns / 1ps

/* Testbench skeleton for tt_um_example
   - Dumps waveforms into tb.vcd
   - Instantiates the DUT
   - Includes clock and reset generation
   - No functional test cases
*/

module tb ();

  // Dump the signals to a VCD file for waveform viewing
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Inputs
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;

  // Outputs
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  // Power pins for gate-level simulation
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // DUT instantiation
  tt_um_example user_project (

`ifdef GL_TEST
      .VPWR   (VPWR),
      .VGND   (VGND),
`endif

      .ui_in  (ui_in),     // Dedicated inputs
      .uo_out (uo_out),    // Dedicated outputs
      .uio_in (uio_in),    // IOs: Input path
      .uio_out(uio_out),   // IOs: Output path
      .uio_oe (uio_oe),    // IOs: Enable path
      .ena    (ena),       // Enable
      .clk    (clk),       // Clock
      .rst_n  (rst_n)      // Reset (active low)
  );

  // Clock generation (100 MHz -> 10 ns period)
  initial clk = 0;
  always #5 clk = ~clk;

  // Reset & enable initialization
  initial begin
    rst_n = 0;
    ena   = 1'b1;  // keep enabled
    ui_in   = 8'd0;
    uio_in  = 8'd0;

    #20 rst_n = 1; // release reset after 20 ns
  end

endmodule
