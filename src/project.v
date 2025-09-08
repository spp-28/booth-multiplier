/*
 * Booth Multiplier Example for TinyTapeout
 * Author: Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Multiplicand
    output wire [7:0] uo_out,   // Lower 8 bits of product
    input  wire [7:0] uio_in,   // Multiplier
    output wire [7:0] uio_out,  // Not used
    output wire [7:0] uio_oe,   // Not used
    input  wire       ena,      // always 1 when powered
    input  wire       clk,      // clock (not used for pure combinational)
    input  wire       rst_n     // reset_n (not used)
);

  // Signed inputs
  wire signed [7:0] multiplicand = ui_in;
  wire signed [7:0] multiplier   = uio_in;

  // Full product (16-bit signed)
  wire signed [15:0] product;

  assign product = booth_mult(multiplicand, multiplier);

  // Send out lower 8 bits only
  assign uo_out  = product[7:0];
  assign uio_out = 0;
  assign uio_oe  = 0;

  // Function implementing Booth’s algorithm
  function signed [15:0] booth_mult;
    input signed [7:0] mcand;
    input signed [7:0] mplier;
    integer i;
    reg [16:0] acc;   // accumulator with extra bit
    reg [8:0]  q;     // multiplier with Q-1 bit
    begin
      acc = 0;
      q   = {mplier, 1'b0}; // append Q-1 = 0

      for (i = 0; i < 8; i = i + 1) begin
        case (q[1:0])
          2'b01: acc[16:9] = acc[16:9] + mcand; // add multiplicand
          2'b10: acc[16:9] = acc[16:9] - mcand; // subtract multiplicand
          default: ; // do nothing
        endcase

        // arithmetic right shift {acc, q}
        {acc, q} = {acc, q} >>> 1;
      end
      booth_mult = {acc, q[8:1]}; // 16-bit result
    end
  endfunction

  // Prevent unused input warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
