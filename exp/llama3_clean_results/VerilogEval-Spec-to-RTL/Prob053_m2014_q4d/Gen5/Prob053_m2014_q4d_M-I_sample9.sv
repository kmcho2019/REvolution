module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize 'out' to 0 at the start of the simulation
initial begin
    out = 1'b0; // Initialize 'out' to 0
end

// D flip-flop to update the 'out' signal
always @(posedge clk) begin
    out <= in ^ out; // Update the 'out' signal with the XOR of 'in' and 'out'
end

endmodule