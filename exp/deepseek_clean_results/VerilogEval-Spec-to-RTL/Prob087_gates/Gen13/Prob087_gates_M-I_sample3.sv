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

    // Compute all fundamental operations first
    wire and_out = a & b;
    wire or_out  = a | b;
    wire xor_out = a ^ b;
    wire b_not = ~b;

    // Assign outputs - inverted operations use the fundamental versions
    assign out_and = and_out;
    assign out_or  = or_out;
    assign out_xor = xor_out;
    assign out_nand = ~and_out;
    assign out_nor = ~or_out;
    assign out_xnor = ~xor_out;
    assign out_anotb = a & b_not;

endmodule