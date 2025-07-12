module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Intermediate signals for improved readability
    wire ab_or = a | b;  // high if a or b is high
    wire cd_or = c | d;  // high if c or d is high

    // Output is 1 only if (a or b) and (c or d) are both 1
    assign q = ab_or & cd_or;

endmodule