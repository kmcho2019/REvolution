module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0 to avoid undefined states
);

// Directly implement the XOR operation within the sequential logic
always @(posedge clk) begin
    out <= in ^ out;
end

endmodule