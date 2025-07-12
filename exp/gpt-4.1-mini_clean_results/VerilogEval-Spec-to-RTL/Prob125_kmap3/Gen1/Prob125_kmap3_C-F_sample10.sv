module TopModule (
    input  a,
    input  b,
    input  c,
    input  d, // don't-care input, unused in logic
    output out
);

assign out = a | (c & ~b);

endmodule