module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in; // Perform 100-bit AND operation
    assign out_or = |in;  // Perform 100-bit OR operation
    assign out_xor = ^in; // Perform 100-bit XOR operation

endmodule