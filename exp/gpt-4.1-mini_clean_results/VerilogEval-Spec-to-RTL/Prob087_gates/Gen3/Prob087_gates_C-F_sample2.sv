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

    wire and_ab, or_ab, xor_ab;

    assign and_ab   = a & b;
    assign or_ab    = a | b;
    assign xor_ab   = a ^ b;

    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} =
           {and_ab, or_ab, xor_ab, ~and_ab, ~or_ab, ~xor_ab, a & ~b};

endmodule