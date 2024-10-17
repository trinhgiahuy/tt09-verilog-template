`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Replace tt_um_example with your module name:
  tt_um_trinhgiahuy user_project (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

// Add testbench code here for mar
always #5 clk = ~clk;

initial begin
   clk = 0;
   rst_n = 0;
   ena = 1;
   ui_in = 8'b00000000;
   uio_in = 8'b00000000;

   #10 rst_n = 1;

   // Test case 1: Simple input to MAR
   #10 ui_in = 8'b00001010;   // d_in = 1010, select = 00
   #10 uio_in = 8'b00000101;  // strobe g = 1, g1 = 0, g2 = 0 (enable mar) 
   #20 ui_in = 8'b00101111;   // d_in = 1111, select = 01 (change select)

   // Test case 2: Additional behavior 
   #20 ui_in = 8'b00011100;   // change input to test different select and input values
   #10 uio_in = 8'b00000011;  // modify control signals  
   
   // ADD MORE TESTCASES HERE
   
   #100 $finish;              // Ensure enough time before finishing the test, guarantee simulation stabilized
end

endmodule
