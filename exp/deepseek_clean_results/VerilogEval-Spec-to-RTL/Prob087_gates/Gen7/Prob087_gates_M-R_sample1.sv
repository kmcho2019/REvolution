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

    // Group basic binary operations
    assign {out_and, out_or, out_xor} = {a & b, a | b, a ^ b};
    
    // Group negated operations
    assign {out_nand, out_nor, out_xnor} = {~(a & b), ~(a | b), ~(a ^ b)};
    
    // Special operation
    assign out_anotb = a & ~b;

endmodule