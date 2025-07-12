module TopModule (
    input  a, b,
    output out_and, out_or, out_xor,
    output out_nand, out_nor, out_xnor,
    output out_anotb
);

    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = 
           {a & b, a | b, a ^ b, ~(a & b), ~(a | b), ~(a ^ b), a & ~b};

endmodule