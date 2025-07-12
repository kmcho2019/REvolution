module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7, stage8;
    reg [15:0] product_reg;

    always @(*) begin
        stage1 = (B[0]) ? A : 16'd0;
        stage2 = (B[1]) ? (A << 1) : 16'd0;
        stage3 = (B[2]) ? (A << 2) : 16'd0;
        stage4 = (B[3]) ? (A << 3) : 16'd0;
        stage5 = (B[4]) ? (A << 4) : 16'd0;
        stage6 = (B[5]) ? (A << 5) : 16'd0;
        stage7 = (B[6]) ? (A << 6) : 16'd0;
        stage8 = (B[7]) ? (A << 7) : 16'd0;
    end

    always @(*) begin
        product_reg = stage1 + stage2 + stage3 + stage4 + stage5 + stage6 + stage7 + stage8;
    end

    assign product = product_reg;

endmodule