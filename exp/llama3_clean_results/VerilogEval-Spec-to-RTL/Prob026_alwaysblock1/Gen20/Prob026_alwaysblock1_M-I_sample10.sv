module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

assign out_assign = a & b;

reg out_alwaysblock_reg;
always @(*) begin
    out_alwaysblock_reg = a & b;
end
assign out_alwaysblock = out_alwaysblock_reg;

endmodule