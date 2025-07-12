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

    // Shared inverted signal only where beneficial (b for anotb)
    wire b_not = ~b;

    // Basic logic operations
    assign out_and = a & b;
    assign out_or  = a | b;
    assign out_xor = a ^ b;

    // Inverted versions using direct computation
    assign out_nand = ~(a & b);
    assign out_nor  = ~(a | b);
    assign out_xnor = ~(a ^ b);

    // Special AND-NOT operation using shared inverted b
    assign out_anotb = a & b_not;

endmodule