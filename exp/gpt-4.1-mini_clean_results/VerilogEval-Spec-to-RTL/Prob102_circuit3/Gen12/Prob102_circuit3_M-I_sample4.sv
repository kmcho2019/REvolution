module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    wire nand_ab = na & nb;
    wire nand_cd = nc & nd;

    assign q = ~(nand_ab | nand_cd);

endmodule