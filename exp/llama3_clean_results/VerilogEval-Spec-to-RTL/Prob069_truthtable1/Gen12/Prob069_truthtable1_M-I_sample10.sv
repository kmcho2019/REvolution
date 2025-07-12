// Given that the current implementation is already optimized for the target technology,
// and considering the logic expression is straightforward and correctly implements the truth table,
// the code remains the same as the original solution.

module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

assign f = (x2 & ~x3) | (x1 & x3);

endmodule