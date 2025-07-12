module TopModule(
    input clk,
    input in,
    output reg out
);

reg out_reg; // internal register to hold the flip-flop output
assign out = out_reg; // continuous assignment to drive the output

always @(posedge clk) begin
    out_reg <= in ^ out; // at every positive edge of clk, out_reg is updated with the XOR of 'in' and current 'out'
end

endmodule