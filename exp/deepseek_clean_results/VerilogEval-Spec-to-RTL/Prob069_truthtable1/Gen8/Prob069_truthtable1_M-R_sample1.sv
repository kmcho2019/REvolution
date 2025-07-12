module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Single-line NAND-based MUX implementation
    assign f = ~(~(x1 & x3) & ~(x2 & ~x3));
endmodule