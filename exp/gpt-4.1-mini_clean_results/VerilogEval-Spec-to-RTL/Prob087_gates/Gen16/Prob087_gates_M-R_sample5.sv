module TopModule (
    input  wire a,
    input  wire b,
    output wire out_and,
    output wire out_or,
    output wire out_xor,
    output wire out_nand,
    output wire out_nor,
    output wire out_xnor,
    output wire out_anotb
);

    // Shared intermediate signals
    wire and_ab = a & b;
    wire or_ab  = a | b;
    wire xor_ab = a ^ b;

    // Direct assignments using shared signals
    assign out_and   = and_ab;
    assign out_or    = or_ab;
    assign out_xor   = xor_ab;

    assign out_nand  = ~and_ab;
    assign out_nor   = ~or_ab;
    assign out_xnor  = ~xor_ab;

    assign out_anotb = a & ~b;

endmodule