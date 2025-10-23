module TopModule(
    input clk,
    input in,
    output reg out
);

reg next_out; // Temporary variable to hold the next state of out

always @(posedge clk) begin
    next_out = in ^ out; // Calculate next state
    out <= next_out; // Assign next state to out
end

endmodule