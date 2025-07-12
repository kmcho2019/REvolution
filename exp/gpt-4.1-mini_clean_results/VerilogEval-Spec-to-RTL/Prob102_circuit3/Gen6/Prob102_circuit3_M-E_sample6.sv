module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire na, nb, nc, nd;
    wire nand_ab, nand_cd;
    wire q_nand;

    // Invert inputs using NAND gates (NAND(a,a) = NOT a)
    assign na = ~(a & a);
    assign nb = ~(b & b);
    assign nc = ~(c & c);
    assign nd = ~(d & d);

    // OR using NAND gates: a OR b = NAND(na, nb)
    assign nand_ab = ~(na & nb);
    assign nand_cd = ~(nc & nd);

    // AND using NAND gates: x AND y = NAND(NAND(x,y), NAND(x,y))
    assign q_nand = ~(nand_ab & nand_cd);
    assign q = ~(q_nand & q_nand);

endmodule