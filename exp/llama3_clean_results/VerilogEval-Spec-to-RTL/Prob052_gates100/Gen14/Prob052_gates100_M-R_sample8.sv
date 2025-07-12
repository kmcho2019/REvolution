module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in; // Compute AND operation on all bits
    assign out_or = |in;  // Compute OR operation on all bits
    assign out_xor = ^in; // Compute XOR operation on all bits

endmodule