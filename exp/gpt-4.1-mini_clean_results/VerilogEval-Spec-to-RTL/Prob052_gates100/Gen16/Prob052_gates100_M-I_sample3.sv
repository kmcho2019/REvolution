module TopModule (
    input  [99:0] in,
    output        out_and,  // 100-input AND
    output        out_or,   // 100-input OR
    output        out_xor   // 100-input XOR (parity)
);

    assign out_and = &in;  // Reduction AND of all 100 bits
    assign out_or  = |in;  // Reduction OR of all 100 bits
    assign out_xor = ^in;  // Reduction XOR of all 100 bits (parity)

endmodule