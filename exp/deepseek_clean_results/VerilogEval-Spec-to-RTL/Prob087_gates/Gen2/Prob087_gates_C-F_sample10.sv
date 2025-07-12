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

    // Basic logic operations
    assign out_and = a & b;      // AND
    assign out_or = a | b;       // OR
    assign out_xor = a ^ b;      // XOR
    assign out_nand = ~(a & b);  // NAND
    assign out_nor = ~(a | b);   // NOR
    assign out_xnor = ~(a ^ b);  // XNOR
    assign out_anotb = a & (~b); // A AND-NOT B

endmodule