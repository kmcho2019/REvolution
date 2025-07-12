module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire nor_ab, nor_cd, nand_in;

    // NOR gates instead of OR: a|b = ~(~a & ~b) so a|b = ~nor_ab
    assign nor_ab = ~(a | b);  // NOR is ~(a|b) directly, kept for clarity
    assign nor_cd = ~(c | d);

    // Since nor_ab = ~(a|b), invert it to get (a|b)
    wire or_ab = ~nor_ab;
    wire or_cd = ~nor_cd;

    // AND gate implemented via NAND and inversion: q = (a|b) & (c|d)
    assign nand_in = ~(or_ab & or_cd);
    assign q = ~nand_in;
endmodule