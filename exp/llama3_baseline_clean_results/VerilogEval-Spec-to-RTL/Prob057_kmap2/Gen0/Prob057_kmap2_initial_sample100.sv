module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~a & b) | (~a & ~c & ~d) | (a & c) | (b & ~d);

endmodule