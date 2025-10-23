module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

assign q = (b == 1 || c == 1) ? 1 : 0;

endmodule