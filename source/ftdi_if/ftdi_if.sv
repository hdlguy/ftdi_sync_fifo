module ftdi_if (
    input   logic       clk,
    output  logic[7:0]  data,
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

    // for now let's just make traffic on the tx side.
    assign oe_n = 1;
    assign rd_n = 1;
    logic[7:0] tx_count=0;
    logic[7:0] data_oreg, ila_data;
    assign wr_n = 0;
    always_ff @(posedge clk) begin
        if (txe_n == 0) begin
            tx_count <= tx_count + 1;
            data_oreg <= tx_count;
            ila_data <= tx_count;
        end
    end

    assign data = (oe_n == 1) ? data_oreg : 8'bzzzz_zzzz;    
    
    ftdi_ila ftdi_ila_inst (.clk(clk), .probe0(ila_data), .probe1({rxf_n, txe_n, rd_n, wr_n, oe_n})); // 8, 5

endmodule


