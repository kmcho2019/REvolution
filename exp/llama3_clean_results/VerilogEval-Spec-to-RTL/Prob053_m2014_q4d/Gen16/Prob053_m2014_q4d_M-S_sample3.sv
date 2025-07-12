module TopModule(
    input clk,
    input in,
    output reg out = 1'b0
);

always @(posedge clk) begin
    // Update out with the XOR result at the rising edge of clk
    out <= in ^ out;
end

endmodule