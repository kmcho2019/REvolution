module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_or;
    wire cd_or;

    // Compute OR of inputs a and b
    assign ab_or = a | b;

    // Compute OR of inputs c and d
    assign cd_or = c | d;

    // Output q is high when both ab_or and cd_or are high
    assign q = ab_or & cd_or;

endmodule