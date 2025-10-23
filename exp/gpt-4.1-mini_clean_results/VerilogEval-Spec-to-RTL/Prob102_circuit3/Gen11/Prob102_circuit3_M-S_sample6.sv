module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Simplified logic without redundant parentheses: q = (a | b) & (c | d)
    assign q = (a | b) & (c | d);

endmodule