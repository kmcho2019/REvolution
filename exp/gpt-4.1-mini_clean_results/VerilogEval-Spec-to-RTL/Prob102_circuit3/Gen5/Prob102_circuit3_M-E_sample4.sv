module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Implement OR by mux: a | b = a ? 1 : b
    wire ab_or = a ? 1'b1 : b;

    // Implement OR by mux: c | d = c ? 1 : d
    wire cd_or = c ? 1'b1 : d;

    // Implement AND by mux: ab_or & cd_or = ab_or ? cd_or : 0
    assign q = ab_or ? cd_or : 1'b0;

endmodule