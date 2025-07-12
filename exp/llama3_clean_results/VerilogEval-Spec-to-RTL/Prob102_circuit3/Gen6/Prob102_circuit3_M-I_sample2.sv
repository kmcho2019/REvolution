module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// The existing logic expression is already optimized for the given functionality.
assign q = (a | b) & (c | d);

endmodule