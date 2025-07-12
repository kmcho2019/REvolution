module TopModule(
    input clk,
    input in,
    output reg out
);

// Compute XOR result combinatorially
assign xor_result = in ^ out;

// Initialize 'out' to a default value (0) for deterministic behavior
initial out = 1'b0;

// Sequential logic: Simple D flip-flop
always @(posedge clk) begin
    out <= xor_result; // Update 'out' with the XOR result on positive edge of clk
end

endmodule