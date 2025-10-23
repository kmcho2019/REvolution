module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in;  // Using the bitwise AND operator (&) to perform 4-input AND operation
assign out_or  = |in;  // Using the bitwise OR operator (|) to perform 4-input OR operation
assign out_xor = ^in;  // Using the bitwise XOR operator (^) to perform 4-input XOR operation

endmodule