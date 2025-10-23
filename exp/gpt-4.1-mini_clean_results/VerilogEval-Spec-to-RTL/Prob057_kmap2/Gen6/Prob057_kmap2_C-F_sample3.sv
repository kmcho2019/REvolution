module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Inverted inputs for reuse
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Shared common OR terms to reduce logic duplication
wire na_or_nb = na | nb; // (~a | ~b)
wire a_or_b   = a  | b;  // (a | b)

// Final output expression derived directly from the Karnaugh map:
// Group 1: (~c & ~d & (~a | ~b)) covers cells (00,00), (01,00), (10,00), (00,01)
// Group 2: (~c & d & ~b)        covers cells (01,10)
// Group 3: (c & ~d & ~a)        covers cells (11,01)
// Group 4: (c & d & (a | b))    covers cells (11,11), (10,11), (11,10)
assign out =
    (nc & nd & na_or_nb) |    // ~c & ~d & (~a | ~b)
    (nc & d  & nb)        |    // ~c & d & ~b
    (c  & nd & na)        |    // c & ~d & ~a
    (c  & d  & a_or_b);       // c & d & (a | b)

endmodule