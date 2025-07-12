module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Intermediate signals for clarity and modularity
    wire ab_or = a | b;
    wire cd_or = c | d;

    // Final output combines the intermediate signals
    assign q = ab_or & cd_or;

endmodule