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

wire term1 = nc & (nd & (na | nb) | d & nb); // ~c & ((~d & (~a + ~b)) + (d & ~b))
wire term2 = c  & (d | (nd & na));           // c & (d + (~d & ~a))

assign out = term1 | term2;

endmodule