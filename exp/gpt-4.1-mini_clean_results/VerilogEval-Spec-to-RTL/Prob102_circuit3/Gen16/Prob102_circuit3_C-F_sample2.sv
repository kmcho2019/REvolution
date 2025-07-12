module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    localparam wire ab_or = a | b;
    localparam wire cd_or = c | d;
    assign q = ab_or & cd_or;
endmodule