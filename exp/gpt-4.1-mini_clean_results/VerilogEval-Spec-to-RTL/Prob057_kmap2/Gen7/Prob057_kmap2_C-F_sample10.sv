module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Inverted inputs - computed once for reuse
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Shared OR sub-expressions to avoid duplicated gates
wire na_or_nb = na | nb; // (~a | ~b)
wire a_or_b   = a  | b;  // (a  |  b)

// Intermediate product terms corresponding to Karnaugh map groups
wire term1 = nc & nd & na_or_nb; // ~c & ~d & (~a | ~b)
wire term2 = nc & d  & nb;       // ~c &  d & ~b
wire term3 = c  & nd & na;       //  c & ~d & ~a
wire term4 = c  & d  & a_or_b;   //  c &  d & (a | b)

// Final output is the OR of all product terms
assign out = term1 | term2 | term3 | term4;

endmodule