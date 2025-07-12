module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Output q is asserted when (a or b) AND (c or d) are true
    assign q = (a | b) & (c | d);

endmodule