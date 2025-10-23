module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize 'out' with a default value (0 in this case)
initial out = 1'b0;

// Sequential logic for D flip-flop
always @(posedge clk) begin
    out <= in ^ out; // Update 'out' with the XOR of 'in' and the current state 'out'
end

endmodule