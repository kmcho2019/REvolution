module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Perform AND operation on the entire input
    assign out_and = &(in);

    // Perform OR operation on the entire input
    assign out_or = |(in);

    // Perform XOR operation on the entire input
    assign out_xor = ^(^in);

endmodule