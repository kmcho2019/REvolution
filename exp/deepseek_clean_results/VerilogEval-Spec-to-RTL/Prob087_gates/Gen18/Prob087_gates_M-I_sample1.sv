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

    // Compute base operations first
    wire and_result = a & b;
    wire or_result = a | b;
    wire xor_result = a ^ b;
    
    // Assign outputs using base operations
    assign out_and = and_result;
    assign out_or = or_result;
    assign out_xor = xor_result;
    
    // Inverted outputs from base operations
    assign out_nand = ~and_result;
    assign out_nor = ~or_result;
    assign out_xnor = ~xor_result;
    
    // Special operation
    assign out_anotb = a & ~b;

endmodule