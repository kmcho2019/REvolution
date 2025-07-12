module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in; // Bitwise AND operator (&) is used for the 100-input AND gate
    assign out_or  = |in;  // Bitwise OR operator (|) is used for the 100-input OR gate
    assign out_xor = ^in;  // Bitwise XOR operator (^) is used for the 100-input XOR gate

endmodule