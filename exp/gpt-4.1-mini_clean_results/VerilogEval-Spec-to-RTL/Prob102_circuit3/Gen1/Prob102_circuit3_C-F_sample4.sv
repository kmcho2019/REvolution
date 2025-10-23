module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Intermediate signals for clarity and potential reuse
    wire ab_or = a | b;
    wire cd_or = c | d;

    // Output q is high only if (a or b) and (c or d) are both high
    assign q = ab_or & cd_or;

endmodule