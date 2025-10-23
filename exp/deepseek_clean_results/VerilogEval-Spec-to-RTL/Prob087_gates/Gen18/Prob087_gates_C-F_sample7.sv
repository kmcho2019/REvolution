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

    // Group related operations together using vectorized assignments
    assign {out_and, out_nand} = {a & b, ~(a & b)};
    assign {out_or, out_nor}   = {a | b, ~(a | b)};
    assign {out_xor, out_xnor} = {a ^ b, ~(a ^ b)};
    
    // Separate assignment for unique operation
    assign out_anotb = a & ~b;

endmodule