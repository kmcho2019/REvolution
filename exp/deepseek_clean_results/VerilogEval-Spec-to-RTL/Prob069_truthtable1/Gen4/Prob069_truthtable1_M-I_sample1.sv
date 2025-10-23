module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Implement using only NAND gates: f = NAND(NAND(x2, ~x3), NAND(x1, x3))
    wire not_x3 = ~x3;
    wire nand1 = ~(x2 & not_x3);
    wire nand2 = ~(x1 & x3);
    assign f = ~(nand1 & nand2);
endmodule