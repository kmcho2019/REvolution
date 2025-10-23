module TopModule(
    input  a,
    input  b,
    output out_and = a & b,
    output out_or = a | b,
    output out_xor = a ^ b,
    output out_nand = ~(a & b),
    output out_nor = ~(a | b),
    output out_xnor = ~(a ^ b),
    output out_anotb = a & ~b
);
endmodule