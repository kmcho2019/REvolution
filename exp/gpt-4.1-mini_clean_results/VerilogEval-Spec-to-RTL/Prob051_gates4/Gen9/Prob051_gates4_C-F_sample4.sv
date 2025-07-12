module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Combinational logic using Verilog reduction operators:
    // - out_and: logical AND of all 4 bits
    // - out_or : logical OR of all 4 bits
    // - out_xor: logical XOR of all 4 bits
    // This approach is minimal, efficient, and clearly shows combinational dependencies.
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule