module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Direct implementation of the logic function
assign q = (a | b) & (c | d);

endmodule