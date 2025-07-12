module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Use reduction operators for 4-input logic gates
    assign out_and = &in;  // reduction AND of all bits
    assign out_or  = |in;  // reduction OR of all bits
    assign out_xor = ^in;  // reduction XOR of all bits

endmodule