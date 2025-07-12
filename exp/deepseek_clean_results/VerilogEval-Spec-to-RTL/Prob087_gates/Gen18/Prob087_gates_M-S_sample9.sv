module TopModule (
    input  a, b,
    output out_and, out_or, out_xor,
    output out_nand, out_nor, out_xnor,
    output out_anotb
);
    assign out_and = a & b;
    assign out_or = a | b;
    assign out_xor = a ^ b;
    assign out_nand = ~out_and;
    assign out_nor = ~out_or;
    assign out_xnor = ~out_xor;
    assign out_anotb = a & ~b;
endmodule