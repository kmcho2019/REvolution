module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

assign q = (a && b) || (a && c) || (b && c) || (b && d);

endmodule