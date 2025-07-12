module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Initialize variables to store the result of AND, OR, and XOR operations
    reg out_and_reg;
    reg out_or_reg;
    reg out_xor_reg;

    // Perform AND operation
    assign out_and_reg = &in;

    // Perform OR operation
    assign out_or_reg = |in;

    // Perform XOR operation
    assign out_xor_reg = ^in;

    // Assign results to output ports
    assign out_and = out_and_reg;
    assign out_or = out_or_reg;
    assign out_xor = out_xor_reg;

endmodule