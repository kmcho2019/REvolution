module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &(in);  // Perform AND operation on all bits
    assign out_or = |(in);   // Perform OR operation on all bits
    assign out_xor = ^(in);  // Perform XOR operation on all bits

endmodule