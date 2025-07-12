module TopModule(
    input clk,
    input in,
    output reg out
);

reg next_out; // Signal to hold the next state of out

always @(*) begin
    // Calculate next_out based on the current out and in
    next_out = in ^ out;
end

always @(posedge clk) begin
    // Update out with next_out at the positive edge of clk
    out <= next_out;
end

endmodule