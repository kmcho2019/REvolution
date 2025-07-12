module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Intermediate signals for input groups
    wire w1; // High if a or b is high
    wire w2; // High if c or d is high

    // Compute OR of a and b
    assign w1 = a | b;

    // Compute OR of c and d
    assign w2 = c | d;

    // Output q is AND of these intermediate results
    assign q = w1 & w2;

endmodule