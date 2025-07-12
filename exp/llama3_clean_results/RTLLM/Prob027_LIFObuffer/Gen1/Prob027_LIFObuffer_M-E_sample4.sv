module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output [3:0] dataOut
);

reg [3:0] buffer_reg[0:3];
reg [1:0] wr_ptr, rd_ptr;

always @(posedge Clk) begin
    if (EN) begin
        if (Rst) begin
            // Reset the buffer and pointers
            for (int i = 0; i < 4; i++) begin
                buffer_reg[i] <= 4'b0;
            end
            wr_ptr <= 0;
            rd_ptr <= 0;
        end else begin
            if (RW == 0) begin // Write operation
                if (wr_ptr != rd_ptr + 1) begin
                    buffer_reg[wr_ptr] <= dataIn;
                    wr_ptr <= wr_ptr + 1;
                    if (wr_ptr == 4) begin
                        wr_ptr <= 0;
                    end
                end
            end else if (RW == 1) begin // Read operation
                if (wr_ptr != rd_ptr) begin
                    dataOut <= buffer_reg[rd_ptr];
                    rd_ptr <= rd_ptr + 1;
                    if (rd_ptr == 4) begin
                        rd_ptr <= 0;
                    end
                end
            end
        end
    end
end

// Update the EMPTY and FULL flags
assign EMPTY = (wr_ptr == rd_ptr) ? 1'b1 : 1'b0;
assign FULL = ((wr_ptr == 0 && rd_ptr == 3) || (wr_ptr > rd_ptr && wr_ptr - rd_ptr == 1)) ? 1'b1 : 1'b0;

endmodule