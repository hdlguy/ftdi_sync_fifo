//
module ftdi_if_tb ();

    logic       ftdi_clk;
    wire [7:0]  data;
    logic       rxf_n;
    logic       rd_n;
    logic       oe_n;
    logic       txe_n;
    logic       wr_n;
    logic[7:0]  tx_tdata; 
    logic       tx_tvalid; 
    logic       tx_tready;
    logic[7:0]  rx_tdata;
    logic       rx_tvalid; 
    logic       rx_tready;
    logic clk=0; localparam clk_period=10.0; always #(clk_period/2)  clk=~clk;
    
    ftdi_if uut (
        .ftdi_clk(ftdi_clk), .data(data), .rxf_n(rxf_n), .rd_n(rd_n), .oe_n(oe_n), .txe_n(txe_n), .wr_n(wr_n),
        .clk(clk), .tx_tdata(tx_tdata), .tx_tvalid(tx_tvalid), .tx_tready(tx_tready), .rx_tdata(rx_tdata), .rx_tvalid(rx_tvalid), .rx_tready(rx_tready)
    );

    ft2232hl ftdi_chip (.clkout(ftdi_clk), .rxf_n(rxf_n), .oe_n(oe_n), .rd_n(rd_n), .data(data), .txe_n(txe_n), .wr_n(wr_n));
    
    logic[7:0] tx_count=0;
    always_ff @(posedge clk) begin
        if (tx_tready == 1) tx_count <= tx_count + 1;
    end
    assign tx_tdata = tx_count;
    assign tx_tvalid = 1;
    
    assign rx_tready = 1;

endmodule

/*
module ft2232hl (
    output  logic           clkout,
    output  logic           rxf_n,
    input   logic           oe_n,
    input   logic           rd_n,
    inout   logic[7:0]      data,
    output  logic           txe_n,
    input   logic           wr_n
);

module ftdi_if (
    input   logic       clk,
    inout   logic[7:0]  data,
    input   logic       rxf_n,
    output  logic       rd_n,
    output  logic       oe_n,
    input   logic       txe_n,
    output  logic       wr_n,
    //
    input   logic[7:0]  tx_din, 
    input   logic       tx_dv_in, 
    output  logic       tx_rdy,
    //
    output  logic[7:0]  rx_dout,
    output  logic       rx_dv_out, 
    input   logic       rx_rdy 
);
*/

