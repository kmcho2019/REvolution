module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire nand_ab;
    wire nand_cd;

    // NAND gates used to create NOR equivalents via De Morgan
    assign nand_ab = ~(a & b); // NAND of a and b (equiv to NOR after inversion)
    assign nand_cd = ~(c & d);

    // Final output is NAND of the above two signals
    assign q = ~(nand_ab & nand_cd);
endmodule