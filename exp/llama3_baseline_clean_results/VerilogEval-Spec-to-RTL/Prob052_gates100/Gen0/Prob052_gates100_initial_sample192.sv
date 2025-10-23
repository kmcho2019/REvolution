module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in; // Using bitwise AND operator (&) for 100-input AND gate
assign out_or  = |in; // Using bitwise OR operator (|) for 100-input OR gate
assign out_xor = ^in; // Using bitwise XOR operator (^) for 100-input XOR gate

endmodule