module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

// Use assign statement for out_assign
assign out_assign = a & b;

// Use combinational always block for out_alwaysblock
reg out_alwaysblock_reg;
always @(*) begin
    out_alwaysblock_reg = a & b;
end
assign out_alwaysblock = out_alwaysblock_reg;

endmodule