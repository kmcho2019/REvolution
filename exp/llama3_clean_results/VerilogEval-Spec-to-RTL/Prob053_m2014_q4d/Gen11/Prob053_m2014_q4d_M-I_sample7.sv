module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize 'out' with a default value (0 in this case)
initial out = 1'b0;

// Sequential logic for D flip-flop
always @(posedge clk) begin
    // Create a temporary signal 'next_out' to hold the output of the XOR gate
    reg next_out;
    next_out = in ^ out; // Perform XOR operation using the current state 'out'
    out <= next_out; // Update 'out' with the result of the XOR operation
end

endmodule