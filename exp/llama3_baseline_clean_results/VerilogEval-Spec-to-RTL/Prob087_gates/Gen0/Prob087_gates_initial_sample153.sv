module TopModule(
    input  a,
    input  b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

assign out_and = a & b;
assign out_or = a | b;
assign out_xor = a ^ b;
assign out_nand = ~(a & b);  // NOT (a AND b) is equivalent to a NAND b
assign out_nor = ~(a | b);   // NOT (a OR b) is equivalent to a NOR b
assign out_xnor = ~(a ^ b);  // NOT (a XOR b) is equivalent to a XNOR b
assign out_anotb = a & ~b;   // a AND NOT b

endmodule