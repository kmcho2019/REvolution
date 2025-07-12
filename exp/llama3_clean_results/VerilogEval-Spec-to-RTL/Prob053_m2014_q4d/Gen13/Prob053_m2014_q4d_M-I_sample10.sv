module TopModule(
    input clk,
    input in,
    output reg out
);

// Initialize 'out' to a default value (0) for deterministic behavior
initial out = 1'b0;

// Sequential logic: D flip-flop with XOR operation
reg xor_result; // Temporary variable to hold XOR result
always @(posedge clk) begin
    xor_result = in ^ out; // Combinational part, using blocking assignment
    out <= xor_result; // Sequential update, using non-blocking assignment
end

endmodule