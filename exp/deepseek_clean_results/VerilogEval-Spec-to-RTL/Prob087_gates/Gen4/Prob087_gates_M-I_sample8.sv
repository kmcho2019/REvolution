module TopModule (
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    wire and_out = a & b;
    wire or_out = a | b;
    wire xor_out = a ^ b;
    wire not_b = ~b;

    assign out_and = and_out;
    assign out_nand = ~and_out;
    assign out_or = or_out;
    assign out_nor = ~or_out;
    assign out_xor = xor_out;
    assign out_xnor = ~xor_out;
    assign out_anotb = a & not_b;

endmodule