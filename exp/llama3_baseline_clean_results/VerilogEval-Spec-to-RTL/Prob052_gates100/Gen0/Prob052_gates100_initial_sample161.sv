module TopModule(
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &in; // Using the reduction AND operator (&) to get the AND of all bits in 'in'
assign out_or  = |in; // Using the reduction OR operator (|) to get the OR of all bits in 'in'
assign out_xor = ^in; // Using the reduction XOR operator (^) to get the XOR of all bits in 'in'

endmodule