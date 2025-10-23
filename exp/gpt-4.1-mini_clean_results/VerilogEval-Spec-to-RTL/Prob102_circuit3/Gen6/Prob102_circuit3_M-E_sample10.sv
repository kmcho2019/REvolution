module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_or = a | b;
    wire cd_or = c | d;

    // 2-to-1 mux:
    // If select (ab_or) = 0 -> output 0
    // If select (ab_or) = 1 -> output cd_or
    assign q = ab_or ? cd_or : 1'b0;

endmodule