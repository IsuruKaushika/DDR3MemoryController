// filepath: d:\My6th\HDLProject\16BitRiscProcessor\Top_tb.v
`include "ALU.v"
`include "RegisterFile.v" // Example module
`include "ControlUnit.v"  // Example module
`include "DataMemory.v"   // Example module
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
    reg [5:0] opcodeCU;
    wire [3:0] controlSignals;

    // Declare signals for Data Memory
    reg [15:0] memAddr;
    reg [15:0] memDataIn;
    wire [15:0] memDataOut;
    reg memWriteEnable;

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
        .opcode(opcodeCU),
        .controlSignals(controlSignals)
    );

    // Instantiate Data Memory
    DataMemory mem_inst (
        .addr(memAddr),
        .dataIn(memDataIn),
        .dataOut(memDataOut),
        .writeEnable(memWriteEnable)
    );

    // Instantiate Instruction Memory (if needed)
    InstructionMemory instr_mem_inst (
        .addr(memAddr), // Adjust as necessary
        .dataOut(memDataOut) // Adjust as necessary
    );

    // Initialization
    initial begin
        // Initialize signals
        a = 16'h0000;
        b = 16'h0000;
        mode = 0;
        opcode = 3'b000;
        regAddr = 4'b0000;
        regDataIn = 16'h0000;
        opcodeCU = 6'b000000;
        memAddr = 16'h0000;
        memDataIn = 16'h0000;
        memWriteEnable = 0;

        // Test ALU
        #10 mode = 0; // Test Arithmetic
        #5 a = 16'h0001; b = 16'h0010; opcode = 3'b000; // Example operation
        // Add more ALU tests...

        // Test Register File
        #10 regAddr = 4'b0001; regDataIn = 16'h1234; // Write to register
        // Add more Register File tests...

        // Test Control Unit
        #10 opcodeCU = 6'b000001; // Example opcode
        // Add more Control Unit tests...

        // Test Data Memory
        #10 memAddr = 16'h0002; memDataIn = 16'hABCD; memWriteEnable = 1; // Write to memory
        // Add more Data Memory tests...

        // Finish simulation
        #100 $finish;
    end
endmodule