module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in; // reduction AND operator (&) performs a 100-input AND operation
assign out_or = |in;  // reduction OR operator (|) performs a 100-input OR operation
assign out_xor = ^in; // reduction XOR operator (^) performs a 100-input XOR operation

endmodule