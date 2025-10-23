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

    // Basic binary operations (single gate implementations)
    assign out_and = a & b;
    assign out_or  = a | b;
    assign out_xor = a ^ b;

    // Direct implementations of complemented operations
    assign out_nand = ~(a & b);  // Direct NAND
    assign out_nor  = ~(a | b);  // Direct NOR
    assign out_xnor = ~(a ^ b);  // Direct XNOR

    // Special AND-NOT operation
    assign out_anotb = a & ~b;

endmodule