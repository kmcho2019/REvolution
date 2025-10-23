module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in; // Using the bitwise AND reduction operator (&)
    assign out_or  = |in;  // Using the bitwise OR reduction operator (|)
    assign out_xor = ^in;  // Using the bitwise XOR reduction operator (^)

endmodule