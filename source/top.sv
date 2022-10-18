//
module top (
    input   logic           clkin100,
    //
    //(* IOB = "{TRUE}" *)
    output  logic[7:0]      ftdi_data,
    input   logic           ftdi_rxf_n,
    input   logic           ftdi_txe_n,
    output  logic           ftdi_rd_n,
    output  logic           ftdi_wr_n,
    output  logic           ftdi_siwu_n,
    input   logic           ftdi_clk,
    output  logic           ftdi_oe_n,
    output  logic           ftdi_pwrsav_n
);

    assign ftdi_siwu_n = 1;
    assign ftdi_pwrsav_n = 1;
    
    logic ftdi_clk_buf, fclk;
    IBUF fclk_ibuf (.O(ftdi_clk_buf), .I(ftdi_clk));
    BUFR #(.BUFR_DIVIDE("BYPASS"), .SIM_DEVICE("7SERIES")) fclk_bufr (.O(fclk), .CE(CE), .CLR(CLR), .I(ftdi_clk_buf));

    logic[7:0] ftdi_count;
    always_ff @(posedge fclk) begin
        ftdi_count <= ftdi_count + 1;
    end
    

    logic ftdi_rx_dv_out, ftdi_tx_dv_in, ftdi_rx_rdy, ftdi_tx_rdy;
    logic[7:0] ftdi_rx_dout, ftdi_tx_din;
    ftdi_if ftdi_if_inst (
        .clk(fclk), .data(ftdi_data), .rxf_n(ftdi_rxf_n), .rd_n(ftdi_rd_n), .oe_n(ftdi_oe_n), .txe_n(ftdi_txe_n), .wr_n(ftdi_wr_n),
        .rx_dout(ftdi_rx_dout), .rx_dv_out(ftdi_rx_dv_out), .rx_rdy(ftdi_rx_rdy),
        .tx_din (ftdi_tx_din),  .tx_dv_in (ftdi_tx_dv_in),  .tx_rdy(ftdi_tx_rdy)
    );

endmodule

