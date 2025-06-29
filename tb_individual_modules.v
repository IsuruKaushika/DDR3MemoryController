// filepath: d:\My6th\HDLProject\16BitRiscProcessor\Top_tb.v
`include "ALU.v"
`include "Register.v"  // Example module
`include "ControlUnit.v" // Example module
// Include other modules as needed

module Top_tb();
    // Declare signals for ALU
    reg [15:0] a;
    reg [15:0] b;
    reg [2:0] opcode;
    reg mode;
    wire [31:0] outALU;
    wire za, zb, eq, gt, lt;

    // Declare signals for Register
    reg [15:0] reg_in;
    reg reg_write_enable;
    wire [15:0] reg_out;

    // Declare signals for Control Unit
    reg [3:0] control_signal;
    wire [15:0] control_out;

    // Instantiate ALU
    ALU d1 (
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

    // Instantiate Register
    Register r1 (
        .data_in(reg_in),
        .write_enable(reg_write_enable),
        .data_out(reg_out)
    );

    // Instantiate Control Unit
    ControlUnit cu (
        .control_signal(control_signal),
        .output_signal(control_out)
    );

    // Initialization
    initial begin
        // Initialize ALU signals
        a = 16'h0000;
        b = 16'h0000;
        mode = 0;
        opcode = 3'b000;

        // Initialize Register signals
        reg_in = 16'h0000;
        reg_write_enable = 0;

        // Initialize Control Unit signals
        control_signal = 4'b0000;

        // Start the simulation
        #10;
        // Add test cases here
        // Example ALU test
        mode = 0; // Arithmetic mode
        a = 16'h0001;
        b = 16'h0010;
        opcode = 3'b000; // Example opcode for addition
        #5;

        // Example Register test
        reg_in = 16'h00FF;
        reg_write_enable = 1; // Enable writing to register
        #5;
        reg_write_enable = 0; // Disable writing

        // Example Control Unit test
        control_signal = 4'b0001; // Example control signal
        #5;

        // Add more test cases as needed
        // ...
    end
endmodule