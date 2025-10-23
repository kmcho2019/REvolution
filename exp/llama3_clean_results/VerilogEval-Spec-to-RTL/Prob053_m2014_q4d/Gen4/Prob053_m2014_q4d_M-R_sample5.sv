module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize 'out' to 0 at the start of the simulation
initial begin
    out = 1'b0; // Initialize 'out' to 0
end

// Continuous assignment to calculate the next state
assign next_state = in ^ out;

// D flip-flop to update the 'out' signal
always @(posedge clk) begin
    out <= next_state; // Non-blocking assignment to update the 'out' signal
end

endmodule