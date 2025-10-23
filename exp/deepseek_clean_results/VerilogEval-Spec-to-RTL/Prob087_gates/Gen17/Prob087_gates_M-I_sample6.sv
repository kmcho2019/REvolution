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

    // Basic operations
    assign out_and = a & b;
    assign out_or  = a | b;
    assign out_xor = a ^ b;
    
    // Inverted operations using shared results
    assign out_nand = ~out_and;
    assign out_nor = ~out_or;
    assign out_xnor = ~out_xor;
    
    // Special operation (kept separate as sharing wouldn't help)
    assign out_anotb = a & ~b;

endmodule