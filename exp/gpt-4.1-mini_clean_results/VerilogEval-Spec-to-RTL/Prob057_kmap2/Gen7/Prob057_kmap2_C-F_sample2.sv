module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Invert inputs once for reuse
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Shared common OR terms to reduce gate count and switching
wire na_or_nb = na | nb; // (~a | ~b)
wire a_or_b   = a  | b;  // (a | b)

// Final minimal SOP derived from K-map groups:
// 1) ~c & ~d & (~a | ~b)    covers m0, m1, m2, m8 etc.
// 2) ~c &  d & ~b           covers m4, m6
// 3)  c & ~d & ~a           covers m8, m9
// 4)  c &  d & (a | b)      covers m11, m13, m14, m15
assign out = 
      (nc & nd & na_or_nb)   // group with ~c & ~d & (~a | ~b)
    | (nc &  d & nb)        // group with ~c & d & ~b
    | (c  & nd & na)        // group with c & ~d & ~a
    | (c  &  d & a_or_b);   // group with c & d & (a | b)

endmodule