module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // Register to hold the output of the flip-flop
assign out = out_reg; // Continuous assignment to output

always @(posedge clk) // Update out_reg on the positive edge of clk
begin
    out_reg <= in ^ out_reg; // XOR operation between in and current out_reg
end

endmodule