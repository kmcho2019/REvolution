module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Grouped assignments with explicit comments
    assign out_and = &in[99:0];  // 100-bit AND reduction
    assign out_or  = |in[99:0];  // 100-bit OR reduction
    assign out_xor = ^in[99:0];  // 100-bit XOR reduction

endmodule