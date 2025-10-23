module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// The current implementation is already quite optimized.
// However, we can consider if any minor adjustments could be beneficial,
// such as rearranging the expression or using different operators,
// though such changes are unlikely to yield significant improvements.

assign f = (x2 & ~x3) | (x1 & x3);

endmodule