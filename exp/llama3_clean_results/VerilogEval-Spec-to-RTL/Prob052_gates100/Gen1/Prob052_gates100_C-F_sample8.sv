module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Directly apply reduction operators to the input vector
    assign out_and = &in; // Reduction AND operation
    assign out_or  = |in;  // Reduction OR operation
    assign out_xor = ^in;  // Reduction XOR operation

endmodule