module TopModule(
    input clk,
    input in,
    output out
);

reg intermediate_out;
reg out;

// Initialize 'out' and 'intermediate_out' to default values (0) for deterministic behavior
initial begin
    out = 1'b0;
    intermediate_out = 1'b0;
end

// Combinatorial logic: XOR operation
always @(*) begin
    intermediate_out = in ^ out;
end

// Sequential logic: Two D flip-flops with the second flip-flop driving the first
always @(posedge clk) begin
    // Use non-blocking assignments for updating 'out' and 'intermediate_out'
    out <= intermediate_out;
end

endmodule