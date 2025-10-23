module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Compute OR of inputs a and b
    wire ab_or = a | b;
    // Compute OR of inputs c and d
    wire cd_or = c | d;

    // Output q is high only if (a or b) AND (c or d) are high
    assign q = ab_or & cd_or;

endmodule