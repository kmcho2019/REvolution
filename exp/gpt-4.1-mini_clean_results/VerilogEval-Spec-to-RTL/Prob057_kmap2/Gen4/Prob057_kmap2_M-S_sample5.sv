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

// Minimal sum-of-products derived from the K-map:
assign out = (nc & nd & (na | nb))   // ~c & ~d & (~a + ~b)
           | (nc & d  & nb)          // ~c & d & ~b
           | (c  & nd & na)          // c & ~d & ~a
           | (c  & d  & (a | b));   // c & d & (a + b)

endmodule