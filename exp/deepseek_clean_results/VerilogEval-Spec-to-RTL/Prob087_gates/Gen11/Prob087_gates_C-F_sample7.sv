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

    wire b_not = ~b;  // Shared inverted b signal for power optimization

    // Basic logic operations
    assign out_and = a & b;
    assign out_or  = a | b;
    assign out_xor = a ^ b;

    // Inverted logic operations
    assign out_nand = ~out_and;  // Directly use inverted and
    assign out_nor  = ~out_or;   // Directly use inverted or
    assign out_xnor = ~out_xor;  // Directly use inverted xor

    // Special case operation using shared inverted b
    assign out_anotb = a & b_not;

endmodule