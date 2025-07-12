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

    // Fundamental operations
    wire and_result = a & b;
    wire or_result = a | b;
    wire xor_result = a ^ b;
    
    // Assign fundamental outputs
    assign out_and = and_result;
    assign out_or = or_result;
    assign out_xor = xor_result;
    
    // Complementary outputs derived from fundamentals
    assign out_nand = ~and_result;
    assign out_nor = ~or_result;
    assign out_xnor = ~xor_result;
    
    // Special case operation
    assign out_anotb = a & ~b;

endmodule