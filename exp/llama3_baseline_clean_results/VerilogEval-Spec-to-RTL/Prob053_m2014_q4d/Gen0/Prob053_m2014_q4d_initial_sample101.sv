module TopModule(
    input clk,
    input in,
    output out
);

reg out_reg; // register to hold the output value

always @(posedge clk) begin
    out_reg <= in ^ out_reg; // XOR operation and update at positive edge of clk
end

assign out = out_reg; // continuous assignment to output port

endmodule