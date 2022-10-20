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

    assign ftdi_siwu_n = 1;
    assign ftdi_pwrsav_n = 1;    

    assign clk = clkin100;
    

    logic tx_tvalid, tx_tready, rx_tvalid, rx_tready;
    logic[7:0] rx_tdata, tx_tdata;
    ftdi_if ftdi_if_inst (
        .ftdi_clk(ftdi_clk), .data(ftdi_data), .rxf_n(ftdi_rxf_n), .rd_n(ftdi_rd_n), .oe_n(ftdi_oe_n), .txe_n(ftdi_txe_n), .wr_n(ftdi_wr_n),
        .clk(clk), .tx_tdata(tx_tdata), .tx_tvalid(tx_tvalid), .tx_tready(tx_tready), 
        .rx_tdata(rx_tdata), .rx_tvalid(rx_tvalid), .rx_tready(rx_tready)
    );


    logic[7:0] tx_count=0;
    always_ff @(posedge clk) begin
        if (tx_tready == 1) tx_count <= tx_count + 1;
    end
    assign tx_tdata = tx_count;
    assign tx_tvalid = 1;
    
    assign rx_tready = 1;

    ftdi_ila if_ila (.clk(clk), .probe0({tx_tdata, tx_tvalid, tx_tready, rx_tdata, rx_tvalid, rx_tready})); // 20

endmodule

/*

module ftdi_if (
    input   logic       ftdi_clk,
    inout  logic[7:0]   data,
    input   logic       rxf_n,
    output  logic       rd_n,
    output  logic       oe_n,
    input   logic       txe_n,
    output  logic       wr_n,
    //
    input   logic       clk,
    input   logic[7:0]  tx_tdata, 
    input   logic       tx_tvalid, 
    output  logic       tx_tready,
    output  logic[7:0]  rx_tdata,
    output  logic       rx_tvalid, 
    input   logic       rx_tready 
);

*/
