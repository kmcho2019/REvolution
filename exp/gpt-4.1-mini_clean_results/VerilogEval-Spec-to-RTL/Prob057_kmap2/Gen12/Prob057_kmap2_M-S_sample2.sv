module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~c & ~b) | (~d & ~a) | (d & b) | (c & a);

endmodule