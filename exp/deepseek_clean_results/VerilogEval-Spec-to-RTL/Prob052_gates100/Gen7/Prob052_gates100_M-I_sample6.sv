module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    /* synthesis parallel_case */
    /* synthesis full_case */
    // 100-input AND with balanced tree optimization
    assign out_and = &in /* synthesis keep */;

    // 100-input OR with balanced tree optimization
    assign out_or = |in /* synthesis keep */;

    // 100-input XOR with balanced tree optimization
    assign out_xor = ^in /* synthesis keep */;

endmodule