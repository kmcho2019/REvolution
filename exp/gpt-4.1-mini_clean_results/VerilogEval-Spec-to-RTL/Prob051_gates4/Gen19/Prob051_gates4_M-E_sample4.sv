module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Intermediate signals for pairwise computations
    wire and0, and1;
    wire or0,  or1;
    wire xor0, xor1;

    // Pairwise AND
    and and_gate0(and0, in[0], in[1]);
    and and_gate1(and1, in[2], in[3]);

    // Pairwise OR
    or or_gate0(or0, in[0], in[1]);
    or or_gate1(or1, in[2], in[3]);

    // Pairwise XOR
    xor xor_gate0(xor0, in[0], in[1]);
    xor xor_gate1(xor1, in[2], in[3]);

    // Final outputs from pairwise results
    and out_and_gate(out_and, and0, and1);
    or  out_or_gate(out_or, or0, or1);
    xor out_xor_gate(out_xor, xor0, xor1);
endmodule