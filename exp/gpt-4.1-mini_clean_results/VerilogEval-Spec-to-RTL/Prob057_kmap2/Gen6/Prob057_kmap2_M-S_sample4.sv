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

assign out = 
    (na & (nc | nd)) |     // ~a & (~c | ~d)
    (nb & nc)       |      // ~b & ~c
    (c  & d  & (a | b));   // c & d & (a | b)

endmodule