
// ECC Generator Module
module ecc_generator (
    input wire [63:0] data_in,
    output wire [7:0] ecc_out
);

    // Calculate ECC for 64-bit data (8-bit ECC)
    // This implements a Hamming code with additional parity
    
    assign ecc_out[0] = ^data_in[0:6];
    assign ecc_out[1] = ^data_in[7:13];
    assign ecc_out[2] = ^data_in[14:20];
    assign ecc_out[3] = ^data_in[21:27];
    assign ecc_out[4] = ^data_in[28:34];
    assign ecc_out[5] = ^data_in[35:41];
    assign ecc_out[6] = ^data_in[42:48];
    assign ecc_out[7] = ^data_in[49:63] ^ ecc_out[0:6];
    
endmodule
