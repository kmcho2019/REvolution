module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] stage0, stage1, stage2, stage3, stage4, stage5, stage6, stage7;
    reg [15:0] product_reg;

    always @(posedge clk) begin
        // Stage 0
        if (B[0]) begin
            stage0 <= A;
        end else begin
            stage0 <= 0;
        end

        // Stage 1
        if (B[1]) begin
            stage1 <= A << 1;
        end else begin
            stage1 <= 0;
        end

        // Stage 2
        if (B[2]) begin
            stage2 <= A << 2;
        end else begin
            stage2 <= 0;
        end

        // Stage 3
        if (B[3]) begin
            stage3 <= A << 3;
        end else begin
            stage3 <= 0;
        end

        // Stage 4
        if (B[4]) begin
            stage4 <= A << 4;
        end else begin
            stage4 <= 0;
        end

        // Stage 5
        if (B[5]) begin
            stage5 <= A << 5;
        end else begin
            stage5 <= 0;
        end

        // Stage 6
        if (B[6]) begin
            stage6 <= A << 6;
        end else begin
            stage6 <= 0;
        end

        // Stage 7
        if (B[7]) begin
            stage7 <= A << 7;
        end else begin
            stage7 <= 0;
        end

        // Add all stages
        product_reg <= stage0 + stage1 + stage2 + stage3 + stage4 + stage5 + stage6 + stage7;

        // Output
        product <= product_reg;
    end

endmodule