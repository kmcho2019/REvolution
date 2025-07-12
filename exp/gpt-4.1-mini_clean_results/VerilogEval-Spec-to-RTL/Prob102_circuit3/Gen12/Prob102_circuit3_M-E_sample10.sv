module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_or = a | b;
    wire cd_or = c | d;

    // Use ab_or as select line: if ab_or=1, q=cd_or; else q=0
    assign q = ab_or ? cd_or : 1'b0;
endmodule