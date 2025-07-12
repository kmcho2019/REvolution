module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire ab_equal;
    wire cd_equal;

    assign ab_equal = ~(a ^ b);
    assign cd_equal = ~(c ^ d);

    assign out = (ab_equal & ~cd_equal) | (~ab_equal & cd_equal);

endmodule