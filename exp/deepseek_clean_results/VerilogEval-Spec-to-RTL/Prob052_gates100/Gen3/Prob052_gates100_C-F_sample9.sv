module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Reduction operations on 100-bit input
    assign out_and = &in;  // AND: 1 only if all bits are 1
    assign out_or  = |in;  // OR: 1 if any bit is 1
    assign out_xor = ^in;  // XOR: 1 if odd number of bits are 1

endmodule