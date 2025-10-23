module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);
    wire n1, n2;
    assign n1 = ~(x3 & ~x2);  // Equivalent to ~x3 | x2 but implemented as NAND
    assign n2 = ~(~x3 & ~x1); // Equivalent to x3 | x1 but implemented as NAND
    assign f = ~(n1 & n2);
endmodule