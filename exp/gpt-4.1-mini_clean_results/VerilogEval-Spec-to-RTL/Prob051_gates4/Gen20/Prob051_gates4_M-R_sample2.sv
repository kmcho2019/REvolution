module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Use continuous assignment with bitwise operators for 4-input gates
    assign out_and = &in;  // 4-input AND: all bits ANDed
    assign out_or  = |in;  // 4-input OR: any bit set
    assign out_xor = ^in;  // 4-input XOR: parity of bits
endmodule