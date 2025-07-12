module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Perform AND, OR, and XOR operations on the 100-bit input
    assign out_and = &in;
    assign out_or = |in;
    assign out_xor = ^in;

endmodule