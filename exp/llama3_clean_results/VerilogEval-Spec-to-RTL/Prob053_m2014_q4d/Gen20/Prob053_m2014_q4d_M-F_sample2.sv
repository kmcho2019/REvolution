module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Explicit initialization to avoid X values
);

reg internal_out; // Internal signal to hold the XOR result

always @(posedge clk) begin
    internal_out <= in ^ out; // Compute the XOR result and store it in internal_out
    out <= internal_out; // Update out with the internal_out value
end

endmodule