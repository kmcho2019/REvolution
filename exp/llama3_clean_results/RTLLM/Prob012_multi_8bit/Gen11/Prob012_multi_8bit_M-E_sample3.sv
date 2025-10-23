module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    // Split the multiplier into two 4-bit parts
    wire [3:0] B_MSB = B[7:4];  // Most Significant Bits
    wire [3:0] B_LSB = B[3:0];  // Least Significant Bits

    // Booth multiplier for MSB part
    wire [7:0] prod_MSB;
    booth_multiplier_4bit booth_msbs(
        .A(A),
        .B(B_MSB),
        .product(prod_MSB)
    );

    // Booth multiplier for LSB part
    wire [7:0] prod_LSB;
    booth_multiplier_4bit booth_lsbs(
        .A(A),
        .B(B_LSB),
        .product(prod_LSB)
    );

    // Combine the partial products
    assign product = {prod_MSB, 4'b0} + {8'b0, prod_LSB};

endmodule

// Booth multiplier for 4-bit numbers
module booth_multiplier_4bit(
    input   [7:0] A,  // Multiplicand
    input   [3:0] B,  // Multiplier
    output  [7:0] product  // Product of A and B
);

    // Booth decoding and multiplication
    wire [7:0] p0, p1, p2, p3;
    assign p0 = (B[0] == 1'b1) ? A : 8'b0;
    assign p1 = (B[1] == 1'b1) ? (A << 1) : 8'b0;
    assign p2 = (B[2] == 1'b1) ? (A << 2) : 8'b0;
    assign p3 = (B[3] == 1'b1) ? (A << 3) : 8'b0;

    // Sum the partial products
    assign product = p0 + p1 + p2 + p3;

endmodule