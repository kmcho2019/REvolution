module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Partial reductions using built-in operators on 2-bit slices
    wire partial_and  = &in[1:0];
    wire partial_and2 = &in[3:2];

    wire partial_or   = |in[1:0];
    wire partial_or2  = |in[3:2];

    wire partial_xor  = ^in[1:0];
    wire partial_xor2 = ^in[3:2];

    // Combine partial results for final outputs
    assign out_and = partial_and & partial_and2;
    assign out_or  = partial_or  | partial_or2;
    assign out_xor = partial_xor ^ partial_xor2;

endmodule