module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

wire na_or_nb = na | nb;
wire a_or_b = a | b;

assign out =
    (nc & nd & na_or_nb) |    // ~c & ~d & (~a | ~b)
    (nc & d  & nb)       |    // ~c & d & ~b
    (c  & nd & na)       |    // c & ~d & ~a
    (c  & d  & a_or_b);        // c & d & (a | b)

endmodule