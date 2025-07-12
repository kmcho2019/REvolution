module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output             mul_en_out,
    output     [15:0]  mul_out
);

    // Stage 1: input registers and enable
    reg [7:0] mul_a_reg, mul_b_reg;
    reg       mul_en_stage1;

    // Stage 2: partial products registers
    reg [15:0] pp [7:0];  // partial products for each bit
    reg        mul_en_stage2;

    // Stage 3: first partial sum stage registers
    reg [15:0] sum_stage3_0, sum_stage3_1, sum_stage3_2, sum_stage3_3;
    reg        mul_en_stage3;

    // Stage 4: second partial sum stage registers
    reg [15:0] sum_stage4_0, sum_stage4_1;
    reg        mul_en_stage4;

    // Stage 5: final sum stage registers
    reg [15:0] sum_stage5;
    reg        mul_en_stage5;

    // Pipeline input stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            mul_en_stage1 <= 1'b0;
        end else begin
            mul_en_stage1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: generate and register partial products (shifted multiplicand per multiplier bit)
    always @(posedge clk or negedge rst_n) begin
        integer i;
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                pp[i] <= 16'd0;
            mul_en_stage2 <= 1'b0;
        end else begin
            if (mul_en_stage1) begin
                for (i = 0; i < 8; i = i + 1) begin
                    pp[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
                end
            end else begin
                for (i = 0; i < 8; i = i + 1) begin
                    pp[i] <= 16'd0;
                end
            end
            mul_en_stage2 <= mul_en_stage1;
        end
    end

    // Stage 3: pairwise add partial products (pp[0]+pp[1], pp[2]+pp[3], etc.) and register sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage3_0 <= 16'd0;
            sum_stage3_1 <= 16'd0;
            sum_stage3_2 <= 16'd0;
            sum_stage3_3 <= 16'd0;
            mul_en_stage3 <= 1'b0;
        end else begin
            if (mul_en_stage2) begin
                sum_stage3_0 <= pp[0] + pp[1];
                sum_stage3_1 <= pp[2] + pp[3];
                sum_stage3_2 <= pp[4] + pp[5];
                sum_stage3_3 <= pp[6] + pp[7];
            end else begin
                sum_stage3_0 <= 16'd0;
                sum_stage3_1 <= 16'd0;
                sum_stage3_2 <= 16'd0;
                sum_stage3_3 <= 16'd0;
            end
            mul_en_stage3 <= mul_en_stage2;
        end
    end

    // Stage 4: add the sums from Stage 3 pairwise and register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage4_0 <= 16'd0;
            sum_stage4_1 <= 16'd0;
            mul_en_stage4 <= 1'b0;
        end else begin
            if (mul_en_stage3) begin
                sum_stage4_0 <= sum_stage3_0 + sum_stage3_1;
                sum_stage4_1 <= sum_stage3_2 + sum_stage3_3;
            end else begin
                sum_stage4_0 <= 16'd0;
                sum_stage4_1 <= 16'd0;
            end
            mul_en_stage4 <= mul_en_stage3;
        end
    end

    // Stage 5: final sum of Stage 4 results and register product output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage5 <= 16'd0;
            mul_en_stage5 <= 1'b0;
        end else begin
            if (mul_en_stage4) begin
                sum_stage5 <= sum_stage4_0 + sum_stage4_1;
            end else begin
                sum_stage5 <= 16'd0;
            end
            mul_en_stage5 <= mul_en_stage4;
        end
    end

    // Output enable is the last pipeline stage enable signal
    assign mul_en_out = mul_en_stage5;

    // Output product is gated by output enable
    assign mul_out = mul_en_out ? sum_stage5 : 16'd0;

endmodule