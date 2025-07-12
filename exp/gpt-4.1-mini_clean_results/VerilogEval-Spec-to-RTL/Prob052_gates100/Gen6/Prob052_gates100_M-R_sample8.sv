module TopModule (
    input  [99:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Use built-in reduction operators for combinational logic
    assign out_and = &in;  // Reduction AND of all 100 input bits
    assign out_or  = |in;  // Reduction OR of all 100 input bits
    assign out_xor = ^in;  // Reduction XOR (parity) of all 100 input bits

endmodule