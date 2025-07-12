module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~c & ~d) | (b & ~c) | (a & d);

endmodule