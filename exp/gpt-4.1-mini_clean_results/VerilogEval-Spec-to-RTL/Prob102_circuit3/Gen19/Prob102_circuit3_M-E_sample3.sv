module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire nor_ab, nor_cd;

    assign nor_ab = ~(a | b); // NOR of a and b
    assign nor_cd = ~(c | d); // NOR of c and d
    assign q = ~(nor_ab & nor_cd); // NAND of nor_ab and nor_cd

endmodule