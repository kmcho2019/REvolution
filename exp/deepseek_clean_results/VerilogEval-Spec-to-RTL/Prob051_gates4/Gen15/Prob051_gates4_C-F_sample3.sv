module TopModule (
    input  [3:0] in,      // 4-bit input vector
    output       out_and, // AND of all inputs (true when all bits are 1)
    output       out_or,  // OR of all inputs (true when any bit is 1)
    output       out_xor  // XOR of all inputs (true for odd parity)
);

    // Combinational logic using reduction operators
    assign out_and = &in; // 4-input AND reduction
    assign out_or  = |in; // 4-input OR reduction
    assign out_xor = ^in; // 4-input XOR reduction (parity calculation)

endmodule