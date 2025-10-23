module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Direct sum-of-products implementation from Karnaugh map
// minterms for cells with output '1':
// (c'd'a'b') + (c'd'a b') + (c'd a' b') + (c'd a' b) +
// (c'd' a b) + (c d' a b') + (c d a b') + (c d a b) + (c d' a b)
// Simplified by direct OR of product terms without intermediate wires
assign out = 
    (~c & ~d & ~a & ~b) | (~c & ~d & ~a & b) | (~c & ~d & a & ~b) | (~c & ~d & a & b) |
    (~c & d  & a & b)  | (c  & ~d & a & b) | (c  & d  & a & b) | (c  & d  & a & ~b) | (c  & d  & ~a & b);

endmodule