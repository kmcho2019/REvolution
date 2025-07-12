module TopModule(
    input clk,
    input in,
    output reg out = 1'b0
);

reg next_out; // Temporary variable to hold the next state

always @(*)
    next_out = in ^ out; // Calculate the next state using current 'in' and 'out'

always @(posedge clk)
    out <= next_out; // Update 'out' at the positive edge of the clock

endmodule