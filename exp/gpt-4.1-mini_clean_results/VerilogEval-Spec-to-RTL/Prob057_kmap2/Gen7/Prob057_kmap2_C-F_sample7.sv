module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Shared sub-expressions
wire ab_or = a | b;
wire na_nb_or = na | nb;

assign out =
    (nc & nd & na_nb_or) |   // ~c & ~d & (~a | ~b)
    (nc & d  & nb)       |   // ~c & d & ~b
    (c  & nd & na)       |   // c & ~d & ~a
    (c  & d  & ab_or);       // c & d & (a | b)

endmodule