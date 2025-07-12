module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Intermediate wires for AND gate connections
    wire and_1, and_2;
    // Intermediate wires for OR gate connections
    wire or_1, or_2;
    // Intermediate wires for XOR gate connections
    wire xor_1, xor_2;

    // 4-input AND implemented as cascaded 2-input ANDs
    and AND1(and_1, in[0], in[1]);
    and AND2(and_2, in[2], in[3]);
    and AND_OUT(out_and, and_1, and_2);

    // 4-input OR implemented as cascaded 2-input ORs
    or OR1(or_1, in[0], in[1]);
    or OR2(or_2, in[2], in[3]);
    or OR_OUT(out_or, or_1, or_2);

    // 4-input XOR implemented as cascaded 2-input XORs
    xor XOR1(xor_1, in[0], in[1]);
    xor XOR2(xor_2, in[2], in[3]);
    xor XOR_OUT(out_xor, xor_1, xor_2);

endmodule