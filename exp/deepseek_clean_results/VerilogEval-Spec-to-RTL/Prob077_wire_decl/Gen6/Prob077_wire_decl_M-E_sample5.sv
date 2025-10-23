module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    wire nand_ab = ~(a & b);
    wire nand_cd = ~(c & d);
    wire nand_or = ~(nand_ab & nand_cd);
    
    assign out = ~nand_or;
    assign out_n = nand_or;

endmodule