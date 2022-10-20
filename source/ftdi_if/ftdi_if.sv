// This module is designed to send and receive data to the FT2232HL USB transceiver in Synchronous 245 FIFO mode.
// An MMCM is used to cancel clock delay to meet timing. This was necessary to run on the Neso module that 
// does not put all the interface pins in a single clock region.  Otherwise we would use a BUFR.
// Control logic just waits for the FT2232 to assert either rxf_n or txe_n and then transfers data to and from the fifos.
module ftdi_if (
    input   logic       ftdi_clk,
    inout   logic[7:0]  data,
    input   logic       rxf_n,
    output  logic       rd_n=1,
    output  logic       oe_n=1,
    input   logic       txe_n,
    output  logic       wr_n=1,
    //
    input   logic       clk,
    input   logic[7:0]  tx_tdata,
    input   logic       tx_tvalid,
    output  logic       tx_tready,
    output  logic[7:0]  rx_tdata,
    output  logic       rx_tvalid,
    input   logic       rx_tready
);

    // Clock logic
    //logic ftdi_clk_buf, fclk;
    //IBUF fclk_ibuf (.O(ftdi_clk_buf), .I(ftdi_clk));
    //BUFR #(.BUFR_DIVIDE("BYPASS"), .SIM_DEVICE("7SERIES")) fclk_buf (.O(fclk), .CE(1'b1), .CLR(1'b0), .I(ftdi_clk_buf));
    //BUFG fclk_buf (.O(fclk), .I(ftdi_clk_buf));
    logic fclk, dcm_locked, dcm_locked_q;
    ftdi_clk_wiz clk_wiz_inst (.clk_in1(ftdi_clk), .clk_out1(fclk), .locked(dcm_locked));
    always_ff @(posedge fclk) dcm_locked_q <= dcm_locked;
    

    // State machine
    logic[3:0] state=0, next_state;
    logic rx_fifo_wr, tx_fifo_rd, tx_fifo_empty;
    (* keep = "true" *) logic rd_n_pre;  // the keep properties are needed to push these registers into IOB logic.
    (* keep = "true" *) logic wr_n_pre;
    (* keep = "true" *) logic oe_n_pre;
    (* keep = "true" *) logic dtri_pre;
    (* keep = "true" *) logic [7:0] dtri=8'hff;
    logic [7:0] data_int;
    always_comb begin
    
        // defaults
        next_state = state;
        rd_n_pre = 1;
        wr_n_pre = 1;
        oe_n_pre = 1;
        dtri_pre  = 1;
        rx_fifo_wr = 0;
        tx_fifo_rd = 0;   
        
        case (state)
        
            0: begin
                if (dcm_locked_q==1) begin            
                    next_state = 1;
                end
            end 
            
            1: begin
                if (rxf_n == 0) begin
                    next_state = 2;
                    oe_n_pre = 0;
                    rd_n_pre = 0;
                end else begin
                    if (txe_n == 0) begin
                        next_state = 5;
                        dtri_pre = 0;
                        wr_n_pre = 0;
                    end
                end
            end
            
            2: begin
                if (rxf_n == 1) begin
                    next_state = 3;
                end else begin
                    oe_n_pre = 0;
                    rd_n_pre = 0;
                    rx_fifo_wr = 1;
                end
            end
            
            3: begin
                next_state = 0;
            end
            
            5: begin
                if ((txe_n == 1) || (tx_fifo_empty==1)) begin
                    next_state = 6;
                end else begin
                    dtri_pre = 0;
                    wr_n_pre = 0;
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
    
    always_ff @(posedge fclk) state <= next_state;       
    
    // Rx FIFO
    logic rx_fifo_empty, rx_fifo_full;
    ftdi_if_fifo rx_fifo (
        .wr_clk(fclk),  .wr_en(rx_fifo_wr), .full(rx_fifo_full),    .din(data),      
        .rd_clk(clk),   .rd_en(rx_tready),  .empty(rx_fifo_empty),  .dout(rx_tdata)   
    );
    assign rx_tvalid = ~rx_fifo_empty;


    // Tx FIFO
    logic tx_fifo_full;
    logic[7:0] tx_fifo_dout;
    ftdi_if_fifo tx_fifo (
        .wr_clk(clk),   .wr_en(tx_tvalid),  .full(tx_fifo_full),    .din(tx_tdata),      
        .rd_clk(fclk),  .rd_en(tx_fifo_rd), .empty(tx_fifo_empty),  .dout(tx_fifo_dout)   
    );
    assign tx_tready = ~tx_fifo_full;


    // these registers must go in IOB logic to meet timing.    
    always_ff @(posedge fclk) begin
        oe_n <= oe_n_pre;
        rd_n <= rd_n_pre;
        wr_n <= wr_n_pre;
        if ((tx_fifo_rd==1) && (tx_fifo_empty==0)) data_int <= tx_fifo_dout;
        for (int i=0; i<8; i++) dtri[i] <= dtri_pre;
    end    

    // the tri-state signals are registered individually in the IOB so we break them out here.
    assign data[0] = (dtri[0] == 0) ? data_int[0]: 1'bz;
    assign data[1] = (dtri[1] == 0) ? data_int[1]: 1'bz;
    assign data[2] = (dtri[2] == 0) ? data_int[2]: 1'bz;
    assign data[3] = (dtri[3] == 0) ? data_int[3]: 1'bz;
    assign data[4] = (dtri[4] == 0) ? data_int[4]: 1'bz;
    assign data[5] = (dtri[5] == 0) ? data_int[5]: 1'bz;
    assign data[6] = (dtri[6] == 0) ? data_int[6]: 1'bz;
    assign data[7] = (dtri[7] == 0) ? data_int[7]: 1'bz;
    
endmodule

/*


*/
