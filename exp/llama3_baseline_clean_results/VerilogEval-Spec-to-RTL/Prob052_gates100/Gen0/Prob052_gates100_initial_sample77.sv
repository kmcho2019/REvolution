module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;  // Reduction AND operator (&) returns 1 if all bits are 1
    assign out_or  = |in;  // Reduction OR operator (|) returns 1 if any bit is 1
    assign out_xor = ^in;  // Reduction XOR operator (^) returns 1 if an odd number of bits are 1

endmodule