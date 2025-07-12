module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Single assign statement implementing the NAND-only logic
    assign f = ~(~(x2 & ~x3) & ~(x1 & x3));
endmodule