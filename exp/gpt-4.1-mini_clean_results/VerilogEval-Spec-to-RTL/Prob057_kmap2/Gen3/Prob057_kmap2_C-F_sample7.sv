module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Inverted inputs
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Shared OR terms to reduce gate count and switching
wire na_or_nb_bar = na | nb; // (~a | ~b)
wire a_or_b       = a  | b;  // (a | b)

assign out =
    (nc & nd & na_or_nb_bar) | // ~c & ~d & (~a | ~b)
    (nc &  d & nb)          | // ~c &  d & ~b
    ( c & nd & na)          | // c  & ~d & ~a
    ( c &  d & a_or_b);       // c  &  d & (a | b)

endmodule