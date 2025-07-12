module TopModule(
    input clk,
    input in,
    output reg out
);

// Combinatorial logic: XOR operation
wire xor_out;
assign xor_out = in ^ out;

// Sequential logic: D flip-flop
always @(posedge clk) begin
    out <= xor_out;  // Update the flip-flop's output
end

// Initialize 'out' to a default value (0) for deterministic behavior
initial begin
    out = 1'b0;
end

endmodule