module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum sum-of-products form
assign out_sop = (b & ~a & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Minimum product-of-sums form
// The conditions for output 0 in decimal and their binary representations are:
// 0: 0000, 1: 0001, 4: 0100, 5: 0101, 6: 0110, 9: 1001, 10: 1010, 13: 1101, 14: 1110
// Invert these to get the POS form
assign out_pos = ~( (~a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & ~b & c & ~d) | (~a & ~b & c & d) | 
                   (~a & b & ~c & ~d) | (~a & b & ~c & d) | (~a & b & c & ~d) | 
                   (a & ~b & ~c & d) | (a & ~b & c & ~d) | (a & ~b & c & d) | 
                   (a & b & ~c & ~d) | (a & b & c & ~d));

endmodule