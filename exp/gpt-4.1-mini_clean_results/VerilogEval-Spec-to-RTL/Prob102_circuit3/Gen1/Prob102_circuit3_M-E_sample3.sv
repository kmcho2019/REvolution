module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire ab_nor;
    wire cd_nor;

    assign ab_nor = ~(a | b);
    assign cd_nor = ~(c | d);
    assign q = ~(ab_nor | cd_nor);
endmodule