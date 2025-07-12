module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Compute AND of first two and last two inputs, then combine
    assign out_and = (&in[1:0]) & (&in[3:2]);

    // Compute OR of first two and last two inputs, then combine
    assign out_or  = (|in[1:0]) | (|in[3:2]);

    // XOR of all inputs using reduction operator
    assign out_xor = ^in;

endmodule