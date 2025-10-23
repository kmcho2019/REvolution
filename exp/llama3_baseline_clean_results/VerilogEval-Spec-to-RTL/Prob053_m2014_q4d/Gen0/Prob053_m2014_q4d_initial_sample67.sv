module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // Internal register to hold the output value
assign out = out_reg; // Continuous assignment to output

always @(posedge clk) // Positive edge triggered
begin
    out_reg <= in ^ out_reg; // Update out_reg with the XOR of 'in' and current 'out_reg'
end

endmodule