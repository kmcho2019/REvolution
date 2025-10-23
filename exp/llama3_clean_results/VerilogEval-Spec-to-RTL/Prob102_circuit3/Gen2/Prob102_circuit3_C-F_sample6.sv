module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// The most straightforward implementation of the required logic function
assign q = (a || b) && (c || d);

endmodule