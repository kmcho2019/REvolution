module TopModule(
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

    assign out_and = a & b;       // a and b
    assign out_or = a | b;        // a or b
    assign out_xor = a ^ b;       // a xor b
    assign out_nand = ~(a & b);   // a nand b
    assign out_nor = ~(a | b);    // a nor b
    assign out_xnor = ~(a ^ b);   // a xnor b
    assign out_anotb = a & ~b;    // a and-not b

endmodule