module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

assign q = (a && !(b || c)) ? 0 : (b || c);

endmodule