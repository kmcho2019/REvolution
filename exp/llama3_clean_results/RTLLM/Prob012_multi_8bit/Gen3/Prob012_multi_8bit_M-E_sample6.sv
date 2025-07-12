module multi_8bit(
    input [7:0] A,  // First 8-bit input operand (multiplicand)
    input [7:0] B,  // Second 8-bit input operand (multiplier)
    output [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7, stage8;
    reg [15:0] prod;

    // Initialize product to 0
    initial prod = 0;

    // Stage 1: Check bit 0 of B and add A if set
    always @(*) begin
        if (B[0] == 1'b1) begin
            stage1 = A;
        end else begin
            stage1 = 0;
        end
    end

    // Stage 2: Check bit 1 of B, shift A, and add to stage1 if set
    always @(*) begin
        if (B[1] == 1'b1) begin
            stage2 = stage1 + (A << 1);
        end else begin
            stage2 = stage1;
        end
    end

    // Stage 3: Check bit 2 of B, shift A, and add to stage2 if set
    always @(*) begin
        if (B[2] == 1'b1) begin
            stage3 = stage2 + (A << 2);
        end else begin
            stage3 = stage2;
        end
    end

    // Stage 4: Check bit 3 of B, shift A, and add to stage3 if set
    always @(*) begin
        if (B[3] == 1'b1) begin
            stage4 = stage3 + (A << 3);
        end else begin
            stage4 = stage3;
        end
    end

    // Stage 5: Check bit 4 of B, shift A, and add to stage4 if set
    always @(*) begin
        if (B[4] == 1'b1) begin
            stage5 = stage4 + (A << 4);
        end else begin
            stage5 = stage4;
        end
    end

    // Stage 6: Check bit 5 of B, shift A, and add to stage5 if set
    always @(*) begin
        if (B[5] == 1'b1) begin
            stage6 = stage5 + (A << 5);
        end else begin
            stage6 = stage5;
        end
    end

    // Stage 7: Check bit 6 of B, shift A, and add to stage6 if set
    always @(*) begin
        if (B[6] == 1'b1) begin
            stage7 = stage6 + (A << 6);
        end else begin
            stage7 = stage6;
        end
    end

    // Stage 8: Check bit 7 of B, shift A, and add to stage7 if set
    always @(*) begin
        if (B[7] == 1'b1) begin
            stage8 = stage7 + (A << 7);
        end else begin
            stage8 = stage7;
        end
    end

    // Assign the final product to the output port
    assign product = stage8;

endmodule