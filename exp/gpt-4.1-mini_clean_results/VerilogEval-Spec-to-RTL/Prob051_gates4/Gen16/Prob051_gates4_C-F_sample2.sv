module CombinedGates (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Use built-in reduction operators for minimal and efficient logic
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;
endmodule

module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Instantiate combined gate module to produce all outputs efficiently
    CombinedGates u_combined (
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );
endmodule