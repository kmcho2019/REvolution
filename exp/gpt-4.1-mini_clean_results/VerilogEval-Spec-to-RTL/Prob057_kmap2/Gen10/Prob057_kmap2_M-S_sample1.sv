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

// Simplified sum-of-products from Karnaugh map with fewer product terms:
assign out = (nc & nd & (na | b))
           | (nc & d  & nb)
           | (c  & nd & na)
           | (c  & d  & (a | b));

endmodule