module TopModule(
    input  [3:0] in,
    output wire out_and,  // 4-input AND reduction
    output wire out_or,   // 4-input OR reduction
    output wire out_xor   // 4-input XOR reduction
);

// 4-input AND: all bits of in must be 1
assign out_and = &in;

// 4-input OR: at least one bit of in is 1
assign out_or  = |in;

// 4-input XOR: parity of all bits in
assign out_xor = ^in;

endmodule