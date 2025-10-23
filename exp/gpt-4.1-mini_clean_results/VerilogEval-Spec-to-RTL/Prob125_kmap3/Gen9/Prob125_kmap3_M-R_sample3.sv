module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't-care input, ignored
    output out
);

assign out = (a & ~c) | (c & (a | ~b));

endmodule