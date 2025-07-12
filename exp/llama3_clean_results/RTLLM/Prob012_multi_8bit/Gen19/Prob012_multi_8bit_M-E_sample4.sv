module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Segment the inputs into 4-bit parts
    wire [3:0] A_high = A[7:4];
    wire [3:0] A_low = A[3:0];
    wire [3:0] B_high = B[7:4];
    wire [3:0] B_low = B[3:0];

    // 4x4 multipliers for each segment combination
    wire [7:0] prod_AA;
    wire [7:0] prod_AB;
    wire [7:0] prod_BA;
    wire [7:0] prod_BB;

    // Instantiation of 4x4 multipliers
    multi_4x4 u1(.A(A_high), .B(A_high), .product(prod_AA));
    multi_4x4 u2(.A(A_high), .B(B_high), .product(prod_AB));
    multi_4x4 u3(.A(A_low), .B(A_high), .product(prod_BA));
    multi_4x4 u4(.A(A_low), .B(B_high), .product(prod_BB));

    // Combine the products with appropriate shifts and additions
    wire [15:0] temp_product;
    assign temp_product = (prod_AA << 8) + (prod_AB << 4) + (prod_BA << 4) + prod_BB;

    // Final product
    assign product = temp_product;

endmodule

// A simple 4x4 multiplier module for demonstration
module multi_4x4(
    input   [3:0] A,  // First 4-bit input operand
    input   [3:0] B,  // Second 4-bit input operand
    output  [7:0] product  // 8-bit output representing the product of A and B
);

    assign product = A * B;

endmodule