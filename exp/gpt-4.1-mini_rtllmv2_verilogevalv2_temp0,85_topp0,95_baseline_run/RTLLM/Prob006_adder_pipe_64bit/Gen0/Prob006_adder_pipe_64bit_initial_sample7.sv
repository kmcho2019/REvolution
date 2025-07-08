module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  reg [64:0] result,
    output  reg        o_en
);

    // Pipeline depth: 4 stages, each 16 bits
    // Registers to hold input operands per stage
    reg [15:0] stage0_a, stage0_b;
    reg        stage0_en;

    reg [15:0] stage1_a, stage1_b;
    reg [15:0] stage1_sum;
    reg        stage1_en;
    reg        stage1_carry;

    reg [15:0] stage2_a, stage2_b;
    reg [15:0] stage2_sum;
    reg        stage2_en;
    reg        stage2_carry;

    reg [15:0] stage3_a, stage3_b;
    reg [15:0] stage3_sum;
    reg        stage3_en;
    reg        stage3_carry;

    // Stage 0: Register inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage0_a <= 16'd0;
            stage0_b <= 16'd0;
            stage0_en <= 1'b0;
        end else begin
            if (i_en) begin
                stage0_a <= adda[15:0];
                stage0_b <= addb[15:0];
            end
            stage0_en <= i_en;
        end
    end

    // Stage 1: Add lower 16 bits with carry_in = 0
    wire [16:0] sum_stage1 = {1'b0, stage0_a} + {1'b0, stage0_b};
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum <= 16'd0;
            stage1_carry <= 1'b0;
            stage1_a <= 16'd0;
            stage1_b <= 16'd0;
            stage1_en <= 1'b0;
        end else begin
            if (stage0_en) begin
                stage1_sum <= sum_stage1[15:0];
                stage1_carry <= sum_stage1[16];
                stage1_a <= adda[31:16];
                stage1_b <= addb[31:16];
            end
            stage1_en <= stage0_en;
        end
    end

    // Stage 2: Add next 16 bits + carry from stage 1
    wire [16:0] sum_stage2 = {1'b0, stage1_a} + {1'b0, stage1_b} + stage1_carry;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= 16'd0;
            stage2_carry <= 1'b0;
            stage2_a <= 16'd0;
            stage2_b <= 16'd0;
            stage2_en <= 1'b0;
        end else begin
            if (stage1_en) begin
                stage2_sum <= sum_stage2[15:0];
                stage2_carry <= sum_stage2[16];
                stage2_a <= adda[47:32];
                stage2_b <= addb[47:32];
            end
            stage2_en <= stage1_en;
        end
    end

    // Stage 3: Add next 16 bits + carry from stage 2
    wire [16:0] sum_stage3 = {1'b0, stage2_a} + {1'b0, stage2_b} + stage2_carry;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage3_sum <= 16'd0;
            stage3_carry <= 1'b0;
            stage3_a <= 16'd0;
            stage3_b <= 16'd0;
            stage3_en <= 1'b0;
        end else begin
            if (stage2_en) begin
                stage3_sum <= sum_stage3[15:0];
                stage3_carry <= sum_stage3[16];
                stage3_a <= adda[63:48];
                stage3_b <= addb[63:48];
            end
            stage3_en <= stage2_en;
        end
    end

    // Stage 4: Add highest 16 bits + carry from stage 3
    wire [16:0] sum_stage4 = {1'b0, stage3_a} + {1'b0, stage3_b} + stage3_carry;
    reg [15:0] stage4_sum;
    reg        stage4_carry;
    reg        stage4_en;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage4_sum <= 16'd0;
            stage4_carry <= 1'b0;
            stage4_en <= 1'b0;
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            if (stage3_en) begin
                stage4_sum <= sum_stage4[15:0];
                stage4_carry <= sum_stage4[16];
            end
            stage4_en <= stage3_en;

            // Produce final result and output enable at stage 4
            if (stage4_en) begin
                // Combine all sums and carry out into 65-bit result:
                // result = {carry_out, bits63_48, bits47_32, bits31_16, bits15_0}
                result <= {stage4_carry, stage4_sum, stage3_sum, stage2_sum, stage1_sum};
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

endmodule