module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (c & a) | (~c & ~d & a) | (c & ~a & ~b);

endmodule