module TopModule(
    input x,
    input y,
    output z
);
    assign z = ~(x & y);  // Single NAND operation matching all test cases
endmodule