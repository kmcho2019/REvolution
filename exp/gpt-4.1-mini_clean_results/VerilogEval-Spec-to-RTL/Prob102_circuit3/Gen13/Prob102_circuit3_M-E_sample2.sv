module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire nand_ab;
    wire nand_cd;
    wire ab_or;
    wire cd_or;
    wire nand_final;

    // NAND of inputs (a and b), (c and d)
    assign nand_ab = ~(a & b);
    assign nand_cd = ~(c & d);

    // Invert nand_ab and nand_cd to get OR: a|b and c|d
    assign ab_or = ~(nand_ab & nand_ab); // a | b
    assign cd_or = ~(nand_cd & nand_cd); // c | d

    // NAND the OR outputs then invert to get AND
    assign nand_final = ~(ab_or & cd_or);

    // Invert nand_final to get final AND
    assign q = ~(nand_final & nand_final);

endmodule