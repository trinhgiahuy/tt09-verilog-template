/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_trinhgiahuy (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Internal signals for MAR
  wire [3:0] mar_out;
  wire [3:0] mar_in = ui_in[3:0];
  wire [1:0] mar_sel = ui_in [5:4];
  wire mar_g = uio_in[0];      // Strobe control
  wire mar_g1 = uio_in[1];     // g1 enable
  wire mar_g2 = uio_in[2];     // g2 enable
  wire mar_clr = ~rst_n;       // Active low reset

  mar mar_inst(
    .d_in(mar_in),
    .select(mar_sel),
    .clk(clk),
    .clr(mar_clr),
    .g1(mar_g1),
    .g2(mar_g2),
    .mar_out(mar_out)
  );

  // mar outputs to uo_out
  assign uo_out[3:0] = mar_out;
  assign uo_out[7:4] = 4'b0000;
  // All output pins must be assigned. If not used, assign to 0.
  // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
