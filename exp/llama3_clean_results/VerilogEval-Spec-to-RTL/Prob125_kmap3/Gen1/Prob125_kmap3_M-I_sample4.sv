module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~c & a) | (c & b) | (c & a & ~b);

endmodule