module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored in logic
    output out
);

assign out = (c & (a | ~b)) | (a & ~c);

endmodule