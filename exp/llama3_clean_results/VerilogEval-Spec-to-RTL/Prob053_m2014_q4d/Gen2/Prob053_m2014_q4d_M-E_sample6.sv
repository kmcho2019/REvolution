module TopModule(
    input clk,
    input in,
    output reg out
);

reg next_out; // Signal to hold the next state of the D flip-flop

// Combinational logic block to calculate the next state
always @(*) begin
    next_out = in ^ out; // XOR operation
end

// D flip-flop to update the 'out' signal
always @(posedge clk) begin
    out <= next_out; // Non-blocking assignment to update the 'out' signal
end

endmodule