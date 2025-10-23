module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Reduction operators for optimal wide-input logic
    assign out_and = &in;  // AND of all bits
    assign out_or  = |in;  // OR of all bits
    assign out_xor = ^in;  // XOR of all bits

endmodule