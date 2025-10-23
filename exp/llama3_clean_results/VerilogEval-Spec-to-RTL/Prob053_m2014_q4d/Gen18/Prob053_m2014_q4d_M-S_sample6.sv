module TopModule(
    input clk,
    input in,
    output reg out
);

// Combinatorial logic: XOR operation
wire d = in ^ out;

// Sequential logic: D flip-flop
always @(posedge clk) begin
    out <= d;  // Update the flip-flop's output with the XOR result
end

// Initialize 'out' to a default value (0) for deterministic behavior
initial begin
    out = 1'b0;
end

endmodule