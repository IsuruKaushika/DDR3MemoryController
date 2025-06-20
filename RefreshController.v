
// Refresh Controller Module
module refresh_controller (
    input wire clk,
    input wire reset_n,
    output wire ref_req,
    input wire ref_ack,
    input wire [15:0] tREFI,
    input wire [15:0] tRFC
);

    reg [15:0] refresh_counter;
    reg refresh_pending;
    reg [15:0] refresh_timer;
    
    assign ref_req = (refresh_counter >= tREFI) || refresh_pending;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            refresh_counter <= 0;
            refresh_pending <= 0;
            refresh_timer <= 0;
        end else begin
            if (refresh_counter < tREFI)
                refresh_counter <= refresh_counter + 1;
            
            if (ref_req && ref_ack) begin
                refresh_counter <= 0;
                refresh_pending <= 0;
                refresh_timer <= tRFC;
            end else if (ref_req) begin
                refresh_pending <= 1;
            end
            
            if (refresh_timer > 0)
                refresh_timer <= refresh_timer - 1;
        end
    end
    
endmodule
