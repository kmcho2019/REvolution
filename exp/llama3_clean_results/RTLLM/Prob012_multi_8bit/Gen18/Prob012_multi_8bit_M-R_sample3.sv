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

endmodule

// Example instantiation of the multi_8bit module
module top(
    input   [7:0] A,
    input   [7:0] B,
    output  [15:0] result
);

    // Instantiate the multi_8bit module
    multi_8bit inst_multi_8bit(
        .A(A),  // Input A
        .B(B),  // Input B
        .product(result)  // Output product
    );

endmodule