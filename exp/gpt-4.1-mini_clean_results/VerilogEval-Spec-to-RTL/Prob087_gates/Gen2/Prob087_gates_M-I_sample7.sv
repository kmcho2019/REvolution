module TopModule(
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

wire and_ab;
wire or_ab;

assign and_ab   = a & b;
assign or_ab    = a | b;

assign out_and   = and_ab;
assign out_or    = or_ab;
assign out_xor   = a ^ b;
assign out_nand  = ~and_ab;
assign out_nor   = ~or_ab;
assign out_xnor  = ~(a ^ b);
assign out_anotb = a & ~b;

endmodule