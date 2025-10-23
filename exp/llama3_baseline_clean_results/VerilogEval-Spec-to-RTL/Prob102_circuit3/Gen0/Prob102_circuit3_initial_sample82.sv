module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

assign q = (a | b) & (c == 0 || d == 1);

endmodule