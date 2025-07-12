module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg [7:0]  out
);

    reg [2:0] bit_pos;  // 3-bit index from 0 to 7

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_pos <= 3'd0;
        end else begin
            bit_pos <= (bit_pos == 3'd7) ? 3'd0 : bit_pos + 1;
        end
    end

    always @(*) begin
        out = 8'b00000000;
        out[bit_pos] = 1'b1;
    end

endmodule