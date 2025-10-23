module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Perform AND, OR, and XOR operations on the entire 100-bit input
    assign out_and = &in; // Reduction AND operator
    assign out_or = |in; // Reduction OR operator
    assign out_xor = ^in; // Reduction XOR operator

endmodule