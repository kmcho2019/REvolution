module TopModule (
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

    // Basic logic operations
    assign out_and = a & b;      // a AND b
    assign out_or  = a | b;      // a OR b
    assign out_xor = a ^ b;      // a XOR b

    // Complementary operations
    assign out_nand = ~out_and;  // NOT (a AND b)
    assign out_nor  = ~out_or;   // NOT (a OR b)
    assign out_xnor = ~out_xor;  // NOT (a XOR b)

    // Special AND-NOT operation
    assign out_anotb = a & ~b;   // a AND NOT b

endmodule