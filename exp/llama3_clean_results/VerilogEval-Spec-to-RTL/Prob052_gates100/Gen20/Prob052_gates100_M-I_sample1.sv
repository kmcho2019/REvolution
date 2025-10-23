module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND Operation
    assign out_and = &in;

    // OR Operation
    assign out_or = |in;

    // XOR Operation
    assign out_xor = ^in;

endmodule