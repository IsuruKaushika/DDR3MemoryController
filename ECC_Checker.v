
// ECC Checker Module
module ecc_checker (
    input wire [63:0] data_in,
    input wire [7:0] ecc_in,
    output wire [7:0] syndrome,
    output wire [63:0] corrected_data
);

    wire [7:0] calculated_ecc;
    wire [7:0] syndrome;
    reg [63:0] corrected_data;
    
    ecc_generator u_ecc_gen (
        .data_in(data_in),
        .ecc_out(calculated_ecc)
    );
    
    assign syndrome = calculated_ecc ^ ecc_in;
    
    // Error correction logic
    always @(*) begin
        corrected_data = data_in;
        case (syndrome)
            // Single-bit error correction cases
            8'b00000001: corrected_data[0] = ~data_in[0];
            8'b00000010: corrected_data[1] = ~data_in[1];
            // ... more correction cases ...
            // Double-bit error detection
            default: if (syndrome != 0) $display("ECC uncorrectable error");
        endcase
    end
    
endmodule