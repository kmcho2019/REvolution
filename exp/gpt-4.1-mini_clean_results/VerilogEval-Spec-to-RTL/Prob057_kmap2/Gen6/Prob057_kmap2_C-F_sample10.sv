module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Inverted inputs reused to save gates and power
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Shared OR sub-expressions to reduce duplicated logic
wire na_or_nb = na | nb; // (~a | ~b)
wire a_or_b   = a  | b;  // (a | b)

// Implement Karnaugh map minimized logic with shared signals
assign out =
    (nc & nd & na_or_nb) | // ~c & ~d & (~a | ~b)
    (nc &  d & nb)      | // ~c &  d & ~b
    ( c & nd & na)      | // c  & ~d & ~a
    ( c &  d & a_or_b);   // c  &  d & (a | b)

endmodule