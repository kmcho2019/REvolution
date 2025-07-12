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

    wire and_ab = a & b;

    assign out_and   = and_ab;
    assign out_or    = a | b;
    assign out_xor   = a ^ b;
    assign out_nand  = ~and_ab;
    assign out_nor   = ~(a | b);
    assign out_xnor  = ~(a ^ b);
    assign out_anotb = a & ~b;

endmodule