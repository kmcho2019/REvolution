module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~c & ~d) | (~c & b & d) | (c & ~b) | (a & c & d);

endmodule