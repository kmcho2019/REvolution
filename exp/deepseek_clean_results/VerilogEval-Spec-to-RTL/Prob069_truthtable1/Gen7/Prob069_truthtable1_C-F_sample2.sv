module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // NAND-based MUX implementation of f = x3 ? x1 : x2
    wire not_x3 = ~x3;
    wire nand_x1x3 = ~(x1 & x3);
    wire nand_x2nx3 = ~(x2 & not_x3);
    assign f = ~(nand_x1x3 & nand_x2nx3);
endmodule