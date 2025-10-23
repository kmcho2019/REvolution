module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire ab_any;
    wire cd_any;

    assign ab_any = |{a, b};  // Reduction OR over a and b
    assign cd_any = |{c, d};  // Reduction OR over c and d
    assign q = ab_any & cd_any;

endmodule