
// Initialization FSM Module
module init_fsm (
    input wire clk,
    input wire reset_n,
    input wire phy_init_done,
    input wire phy_ready,
    output wire init_done
);

    reg [3:0] init_state;
    reg [15:0] init_counter;
    reg init_done_reg;
    
    assign init_done = init_done_reg;
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            init_state <= 0;
            init_counter <= 0;
            init_done_reg <= 0;
        end else begin
            case (init_state)
                0: begin // Wait for power stable
                    if (init_counter > 200) begin
                        init_state <= 1;
                        init_counter <= 0;
                    end else begin
                        init_counter <= init_counter + 1;
                    end
                end
                1: begin // Assert reset
                    init_state <= 2;
                    init_counter <= 100; // tINIT1
                end
                // ... more initialization states ...
                15: begin // Initialization complete
                    init_done_reg <= 1;
                end
            endcase
            
            if (init_counter > 0)
                init_counter <= init_counter - 1;
        end
    end
    
endmodule
