module TopModule(
    input  wire [3:0] in,
    output wire       out_and,
    output wire       out_or,
    output wire       out_xor
);

    // 4-input AND implementation
    wire and_temp1, and_temp2;
    and g1(and_temp1, in[0], in[1]);
    and g2(and_temp2, in[2], in[3]);
    and g3(out_and, and_temp1, and_temp2);

    // 4-input OR implementation
    wire or_temp1, or_temp2;
    or g4(or_temp1, in[0], in[1]);
    or g5(or_temp2, in[2], in[3]);
    or g6(out_or, or_temp1, or_temp2);

    // 4-input XOR implementation
    wire xor_temp1, xor_temp2;
    xor g7(xor_temp1, in[0], in[1]);
    xor g8(xor_temp2, in[2], in[3]);
    xor g9(out_xor, xor_temp1, xor_temp2);

endmodule