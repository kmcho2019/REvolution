module TopModule (
    input  [99:0] in,     // 100-bit input vector
    output        out_and, // Reduction AND of all input bits
    output        out_or,  // Reduction OR of all input bits
    output        out_xor  // Reduction XOR of all input bits
);
    assign out_and = &in;  // 100-input AND reduction
    assign out_or  = |in;  // 100-input OR reduction
    assign out_xor = ^in;  // 100-input XOR reduction
endmodule