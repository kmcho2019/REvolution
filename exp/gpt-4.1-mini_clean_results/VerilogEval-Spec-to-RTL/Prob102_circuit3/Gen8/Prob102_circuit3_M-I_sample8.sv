module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Directly assign the output without intermediate wires
    assign q = (a | b) & (c | d);

endmodule