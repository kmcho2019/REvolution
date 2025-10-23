module TopModule(
    input clk,
    input in,
    output reg out
);

reg next_out; // Signal to hold the next state of the D flip-flop

// Initialize 'out' to 0 at the start of the simulation
initial begin
    out = 1'b0; // Initialize 'out' to 0
end

// Combinational logic block to calculate the next state
always @(*) begin
    next_out = in ^ out; // XOR operation
end

// D flip-flop to update the 'out' signal
always @(posedge clk) begin
    out <= next_out; // Non-blocking assignment to update the 'out' signal
end

endmodule