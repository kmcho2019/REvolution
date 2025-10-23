module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

assign q = (a || b) & (c || d);

// Alternatively, the K-map simplification can be explicitly written as:
// assign q = (a & c) | (a & d) | (b & c) | (b & d);

endmodule