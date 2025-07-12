module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;    // Reduction AND of all input bits
    assign out_or  = |in;    // Reduction OR of all input bits
    assign out_xor = ^in;    // Reduction XOR of all input bits

endmodule