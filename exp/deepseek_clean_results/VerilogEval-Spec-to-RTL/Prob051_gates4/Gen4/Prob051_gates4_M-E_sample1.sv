module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Intermediate wires for AND gate
    wire and_01, and_23;
    and AND1(and_01, in[0], in[1]);
    and AND2(and_23, in[2], in[3]);
    and AND_FINAL(out_and, and_01, and_23);

    // Intermediate wires for OR gate
    wire or_01, or_23;
    or OR1(or_01, in[0], in[1]);
    or OR2(or_23, in[2], in[3]);
    or OR_FINAL(out_or, or_01, or_23);

    // Intermediate wires for XOR gate
    wire xor_01, xor_23;
    xor XOR1(xor_01, in[0], in[1]);
    xor XOR2(xor_23, in[2], in[3]);
    xor XOR_FINAL(out_xor, xor_01, xor_23);

endmodule