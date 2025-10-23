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

assign out = 
    (nc & nd & na)       |  // ~c & ~d & ~a
    (nc &  d & na & nb)  |  // ~c & d & ~a & ~b
    ( c &  d & b)        |  // c & d & b
    ( c & nd & na & nb);     // c & ~d & ~a & ~b

endmodule