module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire not_a = ~a;
wire not_b = ~b;
wire not_c = ~c;
wire not_d = ~d;

assign out = (not_c & not_d & (not_a | not_b))
           | (not_c & d     & not_b)
           | (c     & not_d & not_a)
           | (c     & d     & (a | b));

endmodule