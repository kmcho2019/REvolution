module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Using reduction operators with synthesis-friendly coding style
    assign out_and = &in;  // 100-input AND (all bits ANDed together)
    assign out_or  = |in;  // 100-input OR (any bit ORed)
    assign out_xor = ^in;  // 100-input XOR (parity calculation)

    // Synthesis directives
    /* synthesis parallel_case */
    /* synthesis full_case */
    // These help synthesis tools optimize the implementation

endmodule