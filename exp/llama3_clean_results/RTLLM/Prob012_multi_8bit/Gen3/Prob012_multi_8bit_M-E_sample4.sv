module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] stage1_product;
    reg [15:0] stage2_product;
    reg [15:0] stage3_product;
    reg [15:0] stage4_product;
    reg [15:0] stage5_product;
    reg [15:0] stage6_product;
    reg [15:0] stage7_product;
    reg [15:0] stage8_product;

    always @(*) begin
        stage1_product = (B[0] == 1) ? A : 0;
        stage2_product = (B[1] == 1) ? (A << 1) + stage1_product : stage1_product;
        stage3_product = (B[2] == 1) ? (A << 2) + stage2_product : stage2_product;
        stage4_product = (B[3] == 1) ? (A << 3) + stage3_product : stage3_product;
        stage5_product = (B[4] == 1) ? (A << 4) + stage4_product : stage4_product;
        stage6_product = (B[5] == 1) ? (A << 5) + stage5_product : stage5_product;
        stage7_product = (B[6] == 1) ? (A << 6) + stage6_product : stage6_product;
        stage8_product = (B[7] == 1) ? (A << 7) + stage7_product : stage7_product;
        product = stage8_product;
    end

endmodule