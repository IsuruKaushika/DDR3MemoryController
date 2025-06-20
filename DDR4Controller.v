// DDR4 Memory Controller Top Module
module ddr4_controller #(
    parameter ADDR_WIDTH = 17,
    parameter DATA_WIDTH = 64,
    parameter BANK_WIDTH = 3,
    parameter ROW_WIDTH = 16,
    parameter COL_WIDTH = 10,
    parameter DRAM_WIDTH = 8,
    parameter BURST_LENGTH = 8
)(
    // System Interface
    input wire clk,
    input wire reset_n,
    
    // User Interface
    input wire [ADDR_WIDTH-1:0] user_addr,
    input wire [DATA_WIDTH-1:0] user_write_data,
    output wire [DATA_WIDTH-1:0] user_read_data,
    input wire user_cmd_valid,
    input wire user_write_en,
    output wire user_ready,
    output wire user_read_data_valid,
    
    // DDR4 PHY Interface
    output wire [15:0] ddr4_adr,
    output wire [1:0] ddr4_ba,
    output wire ddr4_bg,
    output wire ddr4_cke,
    output wire ddr4_odt,
    output wire ddr4_cs_n,
    output wire ddr4_act_n,
    output wire ddr4_reset_n,
    inout wire [DRAM_WIDTH-1:0] ddr4_dq,
    inout wire [DRAM_WIDTH/8-1:0] ddr4_dqs_t,
    inout wire [DRAM_WIDTH/8-1:0] ddr4_dqs_c,
    output wire ddr4_ck_t,
    output wire ddr4_ck_c,
    output wire ddr4_parity,
    output wire ddr4_alert_n
);

    // Internal wires and registers
    wire [ADDR_WIDTH-1:0] cmd_addr;
    wire cmd_valid;
    wire cmd_write;
    wire cmd_read;
    wire cmd_ready;
    
    wire [DATA_WIDTH-1:0] write_data;
    wire write_data_valid;
    wire write_data_ready;
    
    wire [DATA_WIDTH-1:0] read_data;
    wire read_data_valid;
    
    wire phy_init_done;
    wire phy_ready;
    wire [3:0] phy_burst_cnt;
    
    // Command Scheduler
    command_scheduler #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .BANK_WIDTH(BANK_WIDTH),
        .ROW_WIDTH(ROW_WIDTH),
        .COL_WIDTH(COL_WIDTH)
    ) u_command_scheduler (
        .clk(clk),
        .reset_n(reset_n),
        
        // User Interface
        .user_addr(user_addr),
        .user_cmd_valid(user_cmd_valid),
        .user_write_en(user_write_en),
        .user_ready(user_ready),
        
        // Command FIFO Interface
        .cmd_addr(cmd_addr),
        .cmd_valid(cmd_valid),
        .cmd_write(cmd_write),
        .cmd_read(cmd_read),
        .cmd_ready(cmd_ready),
        
        // Refresh Control
        .ref_req(ref_req),
        .ref_ack(ref_ack),
        
        // Timing Parameters
        .tRC(tRC),
        .tRAS(tRAS),
        .tRP(tRP),
        .tRCD(tRCD),
        .tRRD(tRRD),
        .tFAW(tFAW),
        .tWTR(tWTR),
        .tWR(tWR),
        .tCCD(tCCD)
    );
    
    // Data Path
    data_path #(
        .DATA_WIDTH(DATA_WIDTH),
        .DRAM_WIDTH(DRAM_WIDTH),
        .BURST_LENGTH(BURST_LENGTH)
    ) u_data_path (
        .clk(clk),
        .reset_n(reset_n),
        
        // User Interface
        .user_write_data(user_write_data),
        .user_read_data(user_read_data),
        .user_read_data_valid(user_read_data_valid),
        
        // Command Interface
        .cmd_write(cmd_write),
        .cmd_read(cmd_read),
        .cmd_valid(cmd_valid),
        
        // Internal Data Interface
        .write_data(write_data),
        .write_data_valid(write_data_valid),
        .write_data_ready(write_data_ready),
        
        .read_data(read_data),
        .read_data_valid(read_data_valid),
        
        // PHY Interface
        .phy_burst_cnt(phy_burst_cnt)
    );
    
    // Address/Command Decoder
    addr_cmd_decoder #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .BANK_WIDTH(BANK_WIDTH),
        .ROW_WIDTH(ROW_WIDTH),
        .COL_WIDTH(COL_WIDTH)
    ) u_addr_cmd_decoder (
        .clk(clk),
        .reset_n(reset_n),
        
        // Command Interface
        .cmd_addr(cmd_addr),
        .cmd_valid(cmd_valid),
        .cmd_write(cmd_write),
        .cmd_read(cmd_read),
        .cmd_ready(cmd_ready),
        
        // PHY Command Interface
        .phy_cmd(phy_cmd),
        .phy_addr(phy_addr),
        .phy_bank(phy_bank),
        .phy_bg(phy_bg),
        .phy_act_n(phy_act_n),
        .phy_cs_n(phy_cs_n),
        
        // Timing Control
        .timing_control(timing_control)
    );
    
    // Refresh Controller
    refresh_controller u_refresh_controller (
        .clk(clk),
        .reset_n(reset_n),
        .ref_req(ref_req),
        .ref_ack(ref_ack),
        .tREFI(tREFI),
        .tRFC(tRFC)
    );
    
    // PHY Interface
    ddr4_phy_interface #(
        .DRAM_WIDTH(DRAM_WIDTH),
        .BURST_LENGTH(BURST_LENGTH)
    ) u_phy_interface (
        .clk(clk),
        .reset_n(reset_n),
        
        // Command Interface
        .phy_cmd(phy_cmd),
        .phy_addr(phy_addr),
        .phy_bank(phy_bank),
        .phy_bg(phy_bg),
        .phy_act_n(phy_act_n),
        .phy_cs_n(phy_cs_n),
        
        // Data Interface
        .write_data(write_data),
        .write_data_valid(write_data_valid),
        .write_data_ready(write_data_ready),
        
        .read_data(read_data),
        .read_data_valid(read_data_valid),
        
        // DDR4 PHY Signals
        .ddr4_adr(ddr4_adr),
        .ddr4_ba(ddr4_ba),
        .ddr4_bg(ddr4_bg),
        .ddr4_cke(ddr4_cke),
        .ddr4_odt(ddr4_odt),
        .ddr4_cs_n(ddr4_cs_n),
        .ddr4_act_n(ddr4_act_n),
        .ddr4_reset_n(ddr4_reset_n),
        .ddr4_dq(ddr4_dq),
        .ddr4_dqs_t(ddr4_dqs_t),
        .ddr4_dqs_c(ddr4_dqs_c),
        .ddr4_ck_t(ddr4_ck_t),
        .ddr4_ck_c(ddr4_ck_c),
        .ddr4_parity(ddr4_parity),
        .ddr4_alert_n(ddr4_alert_n),
        
        // Status
        .phy_init_done(phy_init_done),
        .phy_ready(phy_ready),
        .phy_burst_cnt(phy_burst_cnt)
    );
    
    // Timing Controller
    timing_controller u_timing_controller (
        .clk(clk),
        .reset_n(reset_n),
        .timing_control(timing_control),
        .tRC(tRC),
        .tRAS(tRAS),
        .tRP(tRP),
        .tRCD(tRCD),
        .tRRD(tRRD),
        .tFAW(tFAW),
        .tWTR(tWTR),
        .tWR(tWR),
        .tCCD(tCCD),
        .tREFI(tREFI),
        .tRFC(tRFC)
    );
    
    // Initialization FSM
    init_fsm u_init_fsm (
        .clk(clk),
        .reset_n(reset_n),
        .phy_init_done(phy_init_done),
        .phy_ready(phy_ready),
        .init_done(init_done)
    );
    
endmodule
