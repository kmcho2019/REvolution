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

    // Shared common sub-expressions for potential logic optimization
    wire and_ab = a & b;
    wire or_ab  = a | b;
    wire xor_ab = a ^ b;

    assign out_and   = and_ab;
    assign out_or    = or_ab;
    assign out_xor   = xor_ab;
    assign out_nand  = ~and_ab;
    assign out_nor   = ~or_ab;
    assign out_xnor  = ~xor_ab;
    assign out_anotb = a & ~b;

endmodule