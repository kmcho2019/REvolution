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

// Intermediate product terms based on the minimized expression
wire term1 = nc & nd & (na | nb);    // ~c & ~d & (~a | ~b)
wire term2 = nc & d  & nb;            // ~c & d & ~b
wire term3 = c  & nd & na;            // c & ~d & ~a
wire term4 = c  & d  & (a | b);       // c & d & (a | b)

assign out = term1 | term2 | term3 | term4;

endmodule