module TopModule (
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    assign out_and = a & b;         // a AND b
    assign out_or = a | b;          // a OR b
    assign out_xor = a ^ b;         // a XOR b
    assign out_nand = ~(a & b);     // a NAND b
    assign out_nor = ~(a | b);      // a NOR b
    assign out_xnor = ~(a ^ b);     // a XNOR b
    assign out_anotb = a & ~b;      // a AND NOT b

endmodule