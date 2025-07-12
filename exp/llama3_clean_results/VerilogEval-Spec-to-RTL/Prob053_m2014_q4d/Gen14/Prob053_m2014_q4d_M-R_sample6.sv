module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize 'out' to a default value (0) for deterministic behavior
initial out = 1'b0;

// Sequential logic: D flip-flop with XOR operation
always @(posedge clk) begin
    out <= in ^ out; // Directly use XOR result, eliminating the need for an intermediate variable
end

endmodule