module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Intermediate signals for improved readability and modularity
    wire ab_or = a | b;
    wire cd_or = c | d;

    // Output combines the intermediate signals with minimal logic depth
    assign q = ab_or & cd_or;

endmodule