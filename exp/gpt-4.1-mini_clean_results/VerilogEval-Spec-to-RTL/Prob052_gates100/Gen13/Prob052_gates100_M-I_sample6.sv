module TopModule (
    input  [99:0] in,
    output       out_and,  // AND of all inputs
    output       out_or,   // OR of all inputs
    output       out_xor   // XOR of all inputs
);

    // Use built-in reduction operators for efficient synthesis
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule