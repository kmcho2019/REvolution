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

wire or_ab  = a | b;
wire or_nab = na | nb;

// Four main product terms from minimal SOP:
// 1) ~c & ~d & (~a | ~b)  => nc & nd & or_nab
// 2) ~c & d  & ~b         => nc & d  & nb
// 3) c  & ~d & ~a         => c  & nd & na
// 4) c  & d  & (a | b)    => c  & d  & or_ab

assign out = (nc & nd & or_nab)
           | (nc & d  & nb)
           | (c  & nd & na)
           | (c  & d  & or_ab);

endmodule