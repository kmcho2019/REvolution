module TopModule (
    input a,
    input b,
    output out
);
    wire nand_ab;
    wire nand_a_a;
    wire nand_b_b;
    wire nand_nota_notb;
    wire nand_final;

    // NAND for NOT a
    nand(nand_a_a, a, a);        // nand_a_a = ~a
    // NAND for NOT b
    nand(nand_b_b, b, b);        // nand_b_b = ~b

    // NAND for a AND b: NAND followed by NAND to invert
    nand(nand_ab, a, b);         // nand_ab = ~(a & b)
    nand(nand_final, nand_ab, nand_ab); // nand_final = a & b

    // NAND for NOT a AND NOT b: NAND followed by NAND to invert
    nand(nand_nota_notb, nand_a_a, nand_b_b);      // nand_nota_notb = ~(~a & ~b)
    nand(nand_nota_notb, nand_nota_notb, nand_nota_notb); // double inversion to get (~a & ~b)

    // OR = NAND of NANDs inverted
    // OR(a,b) = NAND(NAND(a,a), NAND(b,b))
    // So out = (a&b) OR (~a&~b) = NAND(NAND(a&b), NAND(~a&~b))
    nand(out, nand_final, nand_nota_notb);
endmodule