module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care input, ignored in logic
    output out
);

assign out = a | (c & ~b);

endmodule