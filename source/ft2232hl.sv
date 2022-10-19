// models the FT2232HL in synchronous fifo mode
module ft2232hl (
    output  logic           clkout=0,
    output  logic           rxf_n,
    input   logic           oe_n,
    input   logic           rd_n,
    inout   logic[7:0]      data,
    output  logic           txe_n,
    input   logic           wr_n
);


    localparam clk_period=16.66666; always #(clk_period/2)  clkout=~clkout;
    
    localparam time outdel = 2;

    localparam int xfer_len = 20;
    logic[3:0] state=0, next_state;
    logic cnt_clr, cnt_ena;
    logic[15:0] byte_count;
    logic txe_n_int, rxf_n_int;
    always_comb begin
        // defaults
        next_state = state;
        rxf_n_int = 1;
        txe_n_int = 1;
        cnt_clr = 0;
        cnt_ena = 0;

        case (state) 

            0: begin
                next_state = 1;
                cnt_clr = 1;
            end

            1: begin
                txe_n_int = 0;
                if (wr_n == 0) begin
                    cnt_ena = 1;
                    if (byte_count == xfer_len-1) begin
                        next_state = 2;
                    end
                end
            end

            2: begin
                next_state = 3;
                cnt_clr = 1;
            end

            3: begin
                rxf_n_int = 0;
                if (rd_n == 0) begin
                    cnt_ena = 1;
                    if (byte_count == xfer_len-1) begin
                        next_state = 4;
                    end
                end
            end

            4: begin
                next_state = 0;
            end

            default: begin
                next_state = 0;
            end

        endcase

    end
    
    assign #(outdel) rxf_n = rxf_n_int;
    assign #(outdel) txe_n = txe_n_int;

    always_ff @(posedge clkout) begin

        state <= next_state;

        if (cnt_clr) begin
            byte_count <= 0;
        end else begin
            if (cnt_ena) begin
                byte_count <= byte_count + 1;
            end
        end

    end
    
    assign #(outdel) data = (oe_n == 0) ? (byte_count[7:0]) : (8'bzzzz_zzzz);    
//    always @* begin
//        if (oe_n == 0) begin
//            data = byte_count[7:0];
//        end else begin
//            data = 8'bzzzz_zzzz;
//        end
//    end
    

endmodule

