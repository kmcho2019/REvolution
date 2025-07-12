module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Output q is high when at least one of (a or b) AND at least one of (c or d) is high
    assign q = (a | b) & (c | d);

endmodule