`timescale 1ns/1ps
`include "instruction_Reg.v"

module tb_insReg;

  // Inputs
  reg clk;
  reg loadIR;
  reg [15:0] insin;

  // Outputs
  wire [11:0] address;
  wire [3:0] opcode;

  // Instantiate the module under test
  insReg uut (
    .clk(clk),
    .loadIR(loadIR),
    .insin(insin),
    .address(address),
    .opcode(opcode)
  );

  // Clock generation: toggles every 5ns (period = 10ns)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test stimulus
  initial begin
    $monitor("Time=%0t | loadIR=%b | insin=%b | opcode=%b | address=%b", 
              $time, loadIR, insin, opcode, address);

    // Initial values
    loadIR = 0;
    insin = 16'h0000;

    // Wait some time before starting
    #10;

    // Test case 1
    insin = 16'b1011000011110000; // opcode=1011, address=000011110000
    loadIR = 1;
    #10;
    loadIR = 0;

    // Test case 2
    #10;
    insin = 16'b0101000010101010; // opcode=0101, address=000010101010
    loadIR = 1;
    #10;
    loadIR = 0;

    // Test case 3
    #10;
    insin = 16'b1111000000001111; // opcode=1111, address=000000001111
    loadIR = 1;
    #10;
    loadIR = 0;

    // Finish simulation
    #20 $finish;
  end

endmodule
