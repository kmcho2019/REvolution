module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

always @(posedge clk) begin
    // Update out with the result of in XOR out at the rising edge of clk
    out <= in ^ out;
end

endmodule