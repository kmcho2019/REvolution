module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

    reg [2:0] pos;  // current bit position (0 to 7)

    always @(posedge clk) begin
        if (reset) begin
            pos <= 3'd0;
        end else begin
            pos <= pos + 3'd1;  // wraps around automatically due to 3-bit width
        end
    end

    always @(*) begin
        out = 8'b0;
        out[pos] = 1'b1;
    end

endmodule