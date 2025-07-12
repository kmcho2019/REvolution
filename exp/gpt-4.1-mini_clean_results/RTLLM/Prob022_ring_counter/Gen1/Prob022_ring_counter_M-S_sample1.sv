module ring_counter (
    input  wire       clk,
    input  wire       reset,
    output reg  [7:0] out
);

reg [2:0] index;

always @(posedge clk) begin
    if (reset) begin
        index <= 3'd0;
    end else begin
        index <= index + 3'd1;
    end
end

always @(*) begin
    out = 8'b0;
    out[index] = 1'b1;
end

endmodule