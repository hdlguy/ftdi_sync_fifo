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


    logic[3:0] state=0, next_state;
    logic dtri, rx_fifo_wr, tx_fifo_rd, tx_fifo_empty;
    
    always_comb begin
    
        // defaults
        next_state = state;
        rd_n = 1;
        wr_n = 1;
        oe_n = 1;
        dtri  = 1;
        rx_fifo_wr = 0;
        tx_fifo_rd = 0;   
        
        case (state)
        
            0: begin
                next_state = 1;
            end 
            
            1: begin
                if (rxf_n == 0) begin
                    next_state = 2;
                    oe_n = 0;
                end else begin
                    if (txe_n == 0) begin
                        next_state = 5;
                        dtri = 0;
                    end
                end
            end
            
            2: begin
                oe_n = 0;
                rd_n = 0;
                if (rxf_n == 1) begin
                    next_state = 3;
                end else begin
                    rx_fifo_wr = 1;
                end
            end
            
            3: begin
                next_state = 0;
            end
            
            5: begin
                dtri  = 0;
                if ((txe_n == 1) || (tx_fifo_empty==1)) begin
                    next_state = 6;
                end else begin
                    wr_n = 0;
                    tx_fifo_rd = 1;
                end
            end
            
            6: begin
                next_state = 0;
            end
            
            default: begin
                next_state = 0;
            end
                        
        endcase
    end
       
    always_ff @(posedge ftdi_clk) begin
        state <= next_state;
    end

    
    logic rx_fifo_empty, rx_fifo_full;
    ftdi_if_fifo rx_fifo (
        .wr_clk(ftdi_clk),  .wr_en(rx_fifo_wr), .full(rx_fifo_full),    .din(data),      
        .rd_clk(clk),       .rd_en(rx_tready),  .empty(rx_fifo_empty),  .dout(rx_tdata)   
    );
    assign rx_tvalid = ~rx_fifo_empty;


    logic tx_fifo_full;
    logic[7:0] tx_fifo_dout;
    ftdi_if_fifo tx_fifo (
        .wr_clk(clk),       .wr_en(tx_tvalid),  .full(tx_fifo_full),    .din(tx_tdata),      
        .rd_clk(ftdi_clk),  .rd_en(tx_fifo_rd), .empty(tx_fifo_empty),  .dout(tx_fifo_dout)   
    );
    assign tx_tready = ~tx_fifo_full;


    assign data = (dtri == 0) ? tx_fifo_dout : 8'bzzzz_zzzz;
    
endmodule

/*


*/