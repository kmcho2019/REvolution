module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_or;
    wire cd_or;

    // Compute OR of inputs a and b once
    assign ab_or = a | b;

    // Compute OR of inputs c and d once
    assign cd_or = c | d;

    // Output q is asserted when (a or b) AND (c or d) are true
    assign q = ab_or & cd_or;

endmodule