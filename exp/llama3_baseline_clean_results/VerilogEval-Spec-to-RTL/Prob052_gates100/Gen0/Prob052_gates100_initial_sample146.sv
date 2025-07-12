module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;  // Reduction AND operator (&) applies AND to all bits in the vector
    assign out_or = |in;   // Reduction OR operator (|) applies OR to all bits in the vector
    assign out_xor = ^in;  // Reduction XOR operator (^) applies XOR to all bits in the vector

endmodule