module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

// Reduction AND: output is 1 only if all bits of 'in' are 1
assign out_and = &in;

// Reduction OR: output is 1 if any bit of 'in' is 1
assign out_or  = |in;

// Reduction XOR: output is parity (1 if an odd number of bits in 'in' are 1)
assign out_xor = ^in;

endmodule