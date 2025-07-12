module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in;  // Using the bitwise AND operator (&) to compute the output of the 4-input AND gate
assign out_or  = |in;  // Using the bitwise OR operator (|) to compute the output of the 4-input OR gate
assign out_xor = ^in;  // Using the bitwise XOR operator (^) to compute the output of the 4-input XOR gate

endmodule