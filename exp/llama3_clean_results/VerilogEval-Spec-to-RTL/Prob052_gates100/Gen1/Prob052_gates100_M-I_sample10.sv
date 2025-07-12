module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Perform AND, OR, and XOR operations directly
    assign out_and = &in; // Built-in AND operator for vectors
    assign out_or = |in;  // Built-in OR operator for vectors
    assign out_xor = ^in; // Built-in XOR operator for vectors

endmodule