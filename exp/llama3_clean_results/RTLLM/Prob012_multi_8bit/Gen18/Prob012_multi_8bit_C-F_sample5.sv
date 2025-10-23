// Module: multi_8bit
// Description: 8-bit multiplier using built-in multiplication operator
module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Use built-in multiplication operator to calculate product
    // This approach is straightforward and efficient, leveraging the synthesis tool's optimizations
    assign product = A * B;

    // Considerations for PPA optimizations:
    // - For power reduction, minimizing switching activity within the multiplier could be beneficial.
    // - For timing optimization, examining the synthesis report for potential bottlenecks is recommended.
    // - For area efficiency, a custom shift-and-add implementation might be explored, although this could come at the cost of increased complexity.

endmodule