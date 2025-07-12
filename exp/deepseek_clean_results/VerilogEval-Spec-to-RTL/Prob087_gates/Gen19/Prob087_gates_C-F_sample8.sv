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

    // AND and its complement NAND
    assign {out_and, out_nand} = {a & b, ~(a & b)};
    
    // OR and its complement NOR
    assign {out_or, out_nor} = {a | b, ~(a | b)};
    
    // XOR and its complement XNOR
    assign {out_xor, out_xnor} = {a ^ b, ~(a ^ b)};
    
    // Special operation: a AND NOT b
    assign out_anotb = a & ~b;

endmodule