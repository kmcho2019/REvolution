module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// The optimized implementation of the required logic function
assign q = (a || b) && (c || d);

endmodule