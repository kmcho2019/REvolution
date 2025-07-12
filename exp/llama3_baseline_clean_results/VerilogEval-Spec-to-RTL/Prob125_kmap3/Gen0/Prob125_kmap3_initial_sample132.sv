module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (a & b) | (a & c) | (b & ~c) | (a & b & c);

endmodule