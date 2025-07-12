module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    // Output q is high when at least one of (a, b) AND at least one of (c, d) is high.
    assign q = (a | b) & (c | d);

endmodule