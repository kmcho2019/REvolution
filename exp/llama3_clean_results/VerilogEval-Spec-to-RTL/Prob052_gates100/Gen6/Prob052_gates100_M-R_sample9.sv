module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Compute AND result
    assign out_and = &in;

    // Compute OR result
    assign out_or = |in;

    // Compute XOR result
    assign out_xor = ^in;

endmodule