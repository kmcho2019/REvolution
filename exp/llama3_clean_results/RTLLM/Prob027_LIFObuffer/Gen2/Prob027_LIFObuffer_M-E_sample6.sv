module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] buffer_mem[0:3];
reg [1:0] wr_ptr, rd_ptr;
reg [1:0] count;

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the buffer and pointers
        for (int i = 0; i < 4; i++) begin
            buffer_mem[i] <= 4'b0;
        end
        wr_ptr <= 0;
        rd_ptr <= 0;
        count <= 0;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
        dataOut <= 4'b0;
    end else if (EN) begin
        if (RW == 0) begin // Write operation
            if (count < 4) begin
                buffer_mem[wr_ptr] <= dataIn;
                wr_ptr <= (wr_ptr + 1) % 4;
                count <= count + 1;
                if (count == 4) begin
                    FULL <= 1'b1;
                    EMPTY <= 1'b0;
                end else begin
                    FULL <= 1'b0;
                end
            end
        end else if (RW == 1) begin // Read operation
            if (count > 0) begin
                dataOut <= buffer_mem[rd_ptr];
                rd_ptr <= (rd_ptr + 1) % 4;
                count <= count - 1;
                if (count == 0) begin
                    EMPTY <= 1'b1;
                    FULL <= 1'b0;
                end else begin
                    EMPTY <= 1'b0;
                end
            end
        end
    end
end

endmodule