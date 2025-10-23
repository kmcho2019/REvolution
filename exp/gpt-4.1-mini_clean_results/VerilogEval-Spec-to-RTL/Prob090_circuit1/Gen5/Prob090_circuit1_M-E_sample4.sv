module TopModule(
    input a,
    input b,
    output q
);
    wire nand_out;
    assign nand_out = ~(a & b);
    assign q = ~nand_out;
endmodule