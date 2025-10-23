module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

assign out_assign = ~(~a | ~b);  // NAND of inverted inputs = AND

always @(*) begin
    reg_a = a;
    reg_b = b;
    out_alwaysblock = reg_a & reg_b;
end

reg reg_a, reg_b;

endmodule