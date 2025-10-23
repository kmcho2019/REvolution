module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize 'out' to a default value (0) for deterministic behavior
initial out = 1'b0;

// Sequential logic: D flip-flop with XOR operation
always @(posedge clk) begin
    // Use non-blocking assignment for updating 'out'
    out <= in ^ out;
end

endmodule