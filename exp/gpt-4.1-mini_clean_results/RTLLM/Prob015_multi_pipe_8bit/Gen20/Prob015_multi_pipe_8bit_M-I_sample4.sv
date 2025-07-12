module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Stage 1 registers: inputs and enable
    reg [7:0]  mul_a_reg;
    reg [7:0]  mul_b_reg;
    reg        mul_en_stage1;

    // Stage 2 registers: partial products and enable
    reg [15:0] pp [7:0]; // partial products registered
    reg        mul_en_stage2;

    // Stage 3 registers: sum of partial products in pairs and enable
    reg [15:0] sum_level1 [3:0];
    reg        mul_en_stage3;

    // Stage 4 registers: sum of sums and enable
    reg [15:0] sum_level2 [1:0];
    reg        mul_en_stage4;

    // Stage 5 register: final product and enable
    reg [15:0] mul_out_reg;
    reg        mul_en_stage5;

    integer i;

    // Stage 1: latch inputs and input enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg     <= 8'd0;
            mul_b_reg     <= 8'd0;
            mul_en_stage1 <= 1'b0;
        end else begin
            mul_en_stage1 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Stage 2: generate and register partial products and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 8; i = i + 1)
                pp[i] <= 16'd0;
            mul_en_stage2 <= 1'b0;
        end else begin
            mul_en_stage2 <= mul_en_stage1;
            if (mul_en_stage1) begin
                for (i = 0; i < 8; i = i + 1) begin
                    // Each partial product: multiplicand shifted by i if mul_b_reg[i] is 1, else 0
                    pp[i] <= mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
                end
            end else begin
                for (i = 0; i < 8; i = i + 1)
                    pp[i] <= 16'd0;
            end
        end
    end

    // Stage 3: sum partial products in pairs -> 4 sums, register sums and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 4; i = i + 1)
                sum_level1[i] <= 16'd0;
            mul_en_stage3 <= 1'b0;
        end else begin
            mul_en_stage3 <= mul_en_stage2;
            if (mul_en_stage2) begin
                sum_level1[0] <= pp[0] + pp[1];
                sum_level1[1] <= pp[2] + pp[3];
                sum_level1[2] <= pp[4] + pp[5];
                sum_level1[3] <= pp[6] + pp[7];
            end else begin
                for (i = 0; i < 4; i = i + 1)
                    sum_level1[i] <= 16'd0;
            end
        end
    end

    // Stage 4: sum the sums to 2 sums, register sums and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_level2[0] <= 16'd0;
            sum_level2[1] <= 16'd0;
            mul_en_stage4 <= 1'b0;
        end else begin
            mul_en_stage4 <= mul_en_stage3;
            if (mul_en_stage3) begin
                sum_level2[0] <= sum_level1[0] + sum_level1[1];
                sum_level2[1] <= sum_level1[2] + sum_level1[3];
            end else begin
                sum_level2[0] <= 16'd0;
                sum_level2[1] <= 16'd0;
            end
        end
    end

    // Stage 5: final sum and register product and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg  <= 16'd0;
            mul_en_stage5 <= 1'b0;
        end else begin
            mul_en_stage5 <= mul_en_stage4;
            if (mul_en_stage4)
                mul_out_reg <= sum_level2[0] + sum_level2[1];
            else
                mul_out_reg <= 16'd0;
        end
    end

    // Output: enable and product registered from final stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out    <= 16'd0;
        end else begin
            mul_en_out <= mul_en_stage5;
            mul_out    <= mul_en_stage5 ? mul_out_reg : 16'd0;
        end
    end

endmodule