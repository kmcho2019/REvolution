module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Inverted signals
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Product terms directly mapped from minimal SOP
wire term1 = nc & nd & na;       // ~c & ~d & ~a
wire term2 = nc & nd & nb;       // ~c & ~d & ~b
wire term3 = nc & d  & nb;       // ~c &  d & ~b
wire term4 = c  & nd & na;       //  c & ~d & ~a
wire term5 = c  & d  & a;        //  c &  d &  a
wire term6 = c  & d  & b;        //  c &  d &  b

// Output is OR of all product terms
assign out = term1 | term2 | term3 | term4 | term5 | term6;

endmodule