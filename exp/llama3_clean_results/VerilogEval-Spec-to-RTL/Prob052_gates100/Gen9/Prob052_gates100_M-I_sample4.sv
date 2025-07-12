module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Directly perform AND, OR, and XOR operations using reduction operators
    assign out_and = &in;
    assign out_or = |in;
    assign out_xor = ^in;

endmodule