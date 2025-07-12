module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // 100-input AND: Equivalent to in[0] & in[1] & ... & in[99]
    // Synthesis will optimize this to the most efficient structure
    assign out_and = &in;

    // 100-input OR: Equivalent to in[0] | in[1] | ... | in[99]
    // Will be synthesized as parallel or tree structure for best timing
    assign out_or = |in;

    // 100-input XOR: Equivalent to in[0] ^ in[1] ^ ... ^ in[99]
    // Computes parity of all input bits (odd parity)
    assign out_xor = ^in;

endmodule