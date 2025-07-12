module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Single-line assignment for optimal PPA:
    // out_and = AND of all bits, out_or = OR of all bits, out_xor = XOR of all bits
    assign {out_and, out_or, out_xor} = {&in, |in, ^in};

endmodule