//
module top (
    input   logic           clkin100,
    //
    inout   logic[7:0]      ftdi_data,
    input   logic           ftdi_rxf_n,
    input   logic           ftdi_txe_n,
    output  logic           ftdi_rd_n,
    output  logic           ftdi_wr_n,
    output  logic           ftdi_siwu_n,
    input   logic           ftdi_clk,
    output  logic           ftdi_oe_n,
    output  logic           ftdi_pwrsav_n
);

    assign ftdi_rd_n = 1;
    assign ftdi_wr_n = 1;
    assign ftdi_siwu_n =1;
    assign ftdi_oe_n = 1;
    assign ftdi_pwrsav_n = 1;

    logic[7:0] ftdi_count;
    always_ff @(posedge ftdi_clk) begin
        ftdi_count <= ftdi_count + 1;
    end
    
    ftdi_ila ftdi_ila_inst (.clk(ftdi_clk), .probe0(ftdi_count), .probe1({ftdi_data, ftdi_rxf_n, ftdi_txe_n, ftdi_rd_n, ftdi_wr_n, ftdi_siwu_n, ftdi_oe_n, ftdi_pwrsav_n})); // 8, 15

endmodule


