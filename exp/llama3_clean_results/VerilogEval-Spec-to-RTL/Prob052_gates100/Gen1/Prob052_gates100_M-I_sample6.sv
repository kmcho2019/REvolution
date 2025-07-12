module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Perform AND, OR, and XOR operations directly on the output ports
    assign out_and = &in;  // Using the reduction AND operator (&)
    assign out_or = |in;   // Using the reduction OR operator (|)
    assign out_xor = ^in;  // Using the reduction XOR operator (^)

endmodule