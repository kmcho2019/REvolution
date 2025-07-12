module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire nand_ab, nand_cd;
    
    assign nand_ab = ~(a & b);
    assign nand_cd = ~(c & d);
    assign q = ~(nand_ab & nand_cd);

endmodule