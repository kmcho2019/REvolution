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

    // Core operations computed directly
    assign out_and = a & b;
    assign out_or  = a | b;
    assign out_xor = a ^ b;

    // Shared inversion for complementary outputs
    wire xor_inverted = ~out_xor;
    
    // Inverted operations using most efficient implementation
    assign out_nand = ~out_and;  // Shares AND gate
    assign out_nor  = ~out_or;   // Shares OR gate
    assign out_xnor = xor_inverted;
    
    // Special operation using direct implementation
    assign out_anotb = a & ~b;

endmodule