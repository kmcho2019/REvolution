module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (~a & ~b & c) | (~a & b) | (a & b & ~c);

endmodule