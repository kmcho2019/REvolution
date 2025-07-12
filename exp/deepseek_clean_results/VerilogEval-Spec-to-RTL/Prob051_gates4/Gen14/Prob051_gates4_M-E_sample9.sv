module TopModule(
    input  wire [3:0] in,
    output wire      out_and,
    output wire      out_or,
    output wire      out_xor
);

    // Intermediate wires
    wire and_intermediate;
    wire or_intermediate;
    wire xor_intermediate;

    // 4-input AND as tree of 2-input ANDs
    and AND1(and_intermediate, in[0], in[1]);
    and AND2(out_and, and_intermediate, in[2], in[3]);

    // 4-input OR as tree of 2-input ORs
    or OR1(or_intermediate, in[0], in[1]);
    or OR2(out_or, or_intermediate, in[2], in[3]);

    // 4-input XOR as tree of 2-input XORs
    xor XOR1(xor_intermediate, in[0], in[1]);
    xor XOR2(out_xor, xor_intermediate, in[2], in[3]);

endmodule