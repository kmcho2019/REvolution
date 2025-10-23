module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

assign q = (a == 0) ? (b || c) : (a || b || c);

endmodule