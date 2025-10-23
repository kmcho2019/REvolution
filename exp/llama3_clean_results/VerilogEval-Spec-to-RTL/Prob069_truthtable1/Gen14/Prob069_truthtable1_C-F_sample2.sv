module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Directly compute the output f based on the inputs x3, x2, and x1
// This implementation follows the truth table's logic and is optimized for area and power
assign f = (x2 & ~x3) | (x1 & x3);

endmodule