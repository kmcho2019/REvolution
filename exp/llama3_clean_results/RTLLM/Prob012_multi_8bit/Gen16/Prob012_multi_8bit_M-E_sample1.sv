module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Divide A and B into high and low 4-bit parts
    wire [3:0] A_high = A[7:4];
    wire [3:0] A_low = A[3:0];
    wire [3:0] B_high = B[7:4];
    wire [3:0] B_low = B[3:0];

    // Calculate partial products
    wire [7:0] partial_product_1;  // A_high * B_high
    wire [7:0] partial_product_2;  // A_high * B_low
    wire [7:0] partial_product_3;  // A_low * B_high
    wire [7:0] partial_product_4;  // A_low * B_low

    // Use 4-bit multiplier modules for each partial product
    multi_4bit U1 (.A(A_high), .B(B_high), .product(partial_product_1));
    multi_4bit U2 (.A(A_high), .B(B_low), .product(partial_product_2));
    multi_4bit U3 (.A(A_low), .B(B_high), .product(partial_product_3));
    multi_4bit U4 (.A(A_low), .B(B_low), .product(partial_product_4));

    // Combine partial products to form the final product
    wire [15:0] temp_product_1;  // (A_high * B_high) << 8
    wire [15:0] temp_product_2;  // (A_high * B_low) << 4
    wire [15:0] temp_product_3;  // (A_low * B_high) << 4

    assign temp_product_1 = {partial_product_1, 8'b0};
    assign temp_product_2 = {partial_product_2, 4'b0};
    assign temp_product_3 = {partial_product_3, 4'b0};

    wire [15:0] sum_1;  // temp_product_1 + temp_product_2
    wire [15:0] sum_2;  // temp_product_3 + partial_product_4

    assign sum_1 = temp_product_1 + temp_product_2;
    assign sum_2 = temp_product_3 + {partial_product_4, 4'b0};  // Ensure sum_2 is 16 bits

    assign product = sum_1 + sum_2;

endmodule

// 4-bit multiplier module
module multi_4bit(
    input   [3:0] A,  // First 4-bit input operand (multiplicand)
    input   [3:0] B,  // Second 4-bit input operand (multiplier)
    output  [7:0] product  // 8-bit output representing the product of A and B
);

    assign product = A * B;

endmodule