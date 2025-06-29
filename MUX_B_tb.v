`timescale 1ns/1ps
`include "MUX_B.v"

module tb_muxB;

  // Inputs
  reg clk;
  reg [11:0] in1;
  reg [11:0] in2;
  reg sel;

  // Output
  wire [11:0] outB;

  // Instantiate the muxB module
  muxB uut (
    .clk(clk),
    .in1(in1),
    .in2(in2),
    .sel(sel),
    .outB(outB)
  );

  // Clock generation: toggle every 5ns (period = 10ns)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Apply test stimuli
  initial begin
    $monitor("Time=%0t | sel=%b | in1=%h | in2=%h | outB=%h", 
              $time, sel, in1, in2, outB);

    // Initialize inputs
    sel = 0;
    in1 = 12'hAAA;  // Binary: 101010101010
    in2 = 12'h555;  // Binary: 010101010101

    // Wait for a few clock edges
    #10;
    
    // Test with sel = 0 (should output in2)
    #10 sel = 0;

    // Test with sel = 1 (should output in1)
    #10 sel = 1;

    // Change input values
    #10 in1 = 12'h0F0; in2 = 12'hF0F;

    // Test again with sel = 0
    #10 sel = 0;

    // Test again with sel = 1
    #10 sel = 1;

    // Finish simulation
    #20 $finish;
  end

endmodule
