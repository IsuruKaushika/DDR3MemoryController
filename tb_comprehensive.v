// filepath: d:\My6th\HDLProject\16BitRiscProcessor\Top_tb.v
`include "ALU.v"
`include "RegisterFile.v"  // Example module
`include "ControlUnit.v"   // Example module
`include "DataMemory.v"    // Example module
`include "InstructionMemory.v" // Example module

module Top_tb();
    // Declare signals for ALU
    reg [15:0] a;
    reg [15:0] b;
    reg [2:0] opcode;
    reg mode;
    wire [31:0] outALU;
    wire za, zb, eq, gt, lt;

    // Declare signals for Register File
    reg [3:0] regAddr;
    reg [15:0] regDataIn;
    wire [15:0] regDataOut;

    // Declare signals for Control Unit
    reg [15:0] instruction;
    wire [2:0] controlSignals;

    // Declare signals for Data Memory
    reg [15:0] memAddr;
    reg [15:0] memDataIn;
    wire [15:0] memDataOut;

    // Instantiate ALU
    ALU alu_inst (
        .a(a),
        .b(b),
        .opcode(opcode),
        .mode(mode),
        .outALU(outALU),
        .za(za),
        .zb(zb),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );

    // Instantiate Register File
    RegisterFile regfile_inst (
        .addr(regAddr),
        .dataIn(regDataIn),
        .dataOut(regDataOut)
    );

    // Instantiate Control Unit
    ControlUnit control_inst (
        .instruction(instruction),
        .controlSignals(controlSignals)
    );

    // Instantiate Data Memory
    DataMemory data_mem_inst (
        .addr(memAddr),
        .dataIn(memDataIn),
        .dataOut(memDataOut)
    );

    // Initialization
    initial begin
        // Initialize ALU inputs
        a = 16'h0000;
        b = 16'h0000;
        mode = 0;
        opcode = 3'b000;

        // Initialize Register File inputs
        regAddr = 4'b0000;
        regDataIn = 16'h0000;

        // Initialize Control Unit inputs
        instruction = 16'h0000;

        // Initialize Data Memory inputs
        memAddr = 16'h0000;
        memDataIn = 16'h0000;

        // Add your test cases here
        // Example ALU test
        #10 mode = 0; // Arithmetic mode
        #5 a = 16'h0001; b = 16'h0010; opcode = 3'b000; // ADD
        #10 opcode = 3'b001; // SUB
        #10 opcode = 3'b010; // AND
        #10 opcode = 3'b011; // OR
        #10 opcode = 3'b100; // XOR

        // Example Register File test
        #10 regAddr = 4'b0001; regDataIn = 16'h1234; // Write to register
        #10 regAddr = 4'b0001; // Read from register

        // Example Control Unit test
        #10 instruction = 16'h0001; // Load instruction
        #10 instruction = 16'h0002; // Another instruction

        // Example Data Memory test
        #10 memAddr = 16'h0001; memDataIn = 16'hABCD; // Write to memory
        #10 memAddr = 16'h0001; // Read from memory

        // Finish simulation
        #100 $finish;
    end
endmodule