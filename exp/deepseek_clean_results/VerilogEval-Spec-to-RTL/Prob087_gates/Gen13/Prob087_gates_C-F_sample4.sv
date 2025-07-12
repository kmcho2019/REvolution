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

    // Shared inverted signals for power optimization
    wire a_not = ~a;
    wire b_not = ~b;

    // Basic logic operations
    assign out_and = a & b;
    assign out_or  = a | b;
    assign out_xor = a ^ b;

    // Inverted operations using shared signals (more efficient than inverting outputs)
    assign out_nand = a_not | b_not;  // De Morgan's equivalent
    assign out_nor  = a_not & b_not;  // De Morgan's equivalent
    assign out_xnor = ~(a ^ b);       // Can't be optimized further with shared signals

    // Special AND-NOT operation using shared inverted b
    assign out_anotb = a & b_not;

endmodule