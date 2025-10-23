module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Directly assign the output q based on the inputs a, b, c, and d
    assign q = (a | b) & (c | d);

endmodule