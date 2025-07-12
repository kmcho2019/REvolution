module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

// Reduction AND: output is 1 only if all inputs are 1
assign out_and = &in;

// Reduction OR: output is 1 if any input is 1
assign out_or  = |in;

// Reduction XOR: output is the parity (odd number of 1s yields 1)
assign out_xor = ^in;

endmodule