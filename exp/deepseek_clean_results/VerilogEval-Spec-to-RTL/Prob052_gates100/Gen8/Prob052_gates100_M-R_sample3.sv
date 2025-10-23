module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Continuous assignments using reduction operators
    assign out_and = &in;  // AND reduction of all 100 bits
    assign out_or  = |in;  // OR reduction of all 100 bits
    assign out_xor = ^in;  // XOR reduction of all 100 bits

endmodule