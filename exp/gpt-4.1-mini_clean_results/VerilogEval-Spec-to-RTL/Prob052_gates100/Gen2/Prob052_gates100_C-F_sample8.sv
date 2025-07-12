module TopModule (
    input  [99:0] in,
    output        out_and,  // Output is 1 only if all 100 input bits are 1 (100-input AND)
    output        out_or,   // Output is 1 if any one or more of the 100 input bits is 1 (100-input OR)
    output        out_xor   // Output is the parity of the 100 input bits (100-input XOR)
);

    // Reduction AND: Logical AND of all bits in 'in'
    assign out_and = &in;

    // Reduction OR: Logical OR of all bits in 'in'
    assign out_or  = |in;

    // Reduction XOR: Parity (odd/even number of 1's) of all bits in 'in'
    assign out_xor = ^in;

endmodule