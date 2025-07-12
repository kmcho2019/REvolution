module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg mul_en_reg;

// Input Stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_reg <= 1'b1;
    end else begin
        mul_en_reg <= 1'b0;
    end
end

// Pipeline Stage 1
reg [15:0] stage1_out;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_out <= 16'b0;
    end else if (mul_en_reg) begin
        if (mul_b_reg[0] == 1'b1) begin
            stage1_out <= {8'b0, mul_a_reg};
        end else begin
            stage1_out <= 16'b0;
        end
    end
end

// Pipeline Stage 2
reg [15:0] stage2_out;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_out <= 16'b0;
    end else if (mul_en_reg) begin
        if (mul_b_reg[1] == 1'b1) begin
            stage2_out <= {8'b0, mul_a_reg} << 1;
        end else begin
            stage2_out <= 16'b0;
        end
    end
end

// Pipeline Stage 3
reg [15:0] stage3_out;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_out <= 16'b0;
    end else if (mul_en_reg) begin
        if (mul_b_reg[2] == 1'b1) begin
            stage3_out <= {8'b0, mul_a_reg} << 2;
        end else begin
            stage3_out <= 16'b0;
        end
    end
end

// Pipeline Stage 4
reg [15:0] stage4_out;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage4_out <= 16'b0;
    end else if (mul_en_reg) begin
        if (mul_b_reg[3] == 1'b1) begin
            stage4_out <= {8'b0, mul_a_reg} << 3;
        end else begin
            stage4_out <= 16'b0;
        end
    end
end

// Pipeline Stage 5
reg [15:0] stage5_out;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage5_out <= 16'b0;
    end else if (mul_en_reg) begin
        if (mul_b_reg[4] == 1'b1) begin
            stage5_out <= {8'b0, mul_a_reg} << 4;
        end else begin
            stage5_out <= 16'b0;
        end
    end
end

// Pipeline Stage 6
reg [15:0] stage6_out;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage6_out <= 16'b0;
    end else if (mul_en_reg) begin
        if (mul_b_reg[5] == 1'b1) begin
            stage6_out <= {8'b0, mul_a_reg} << 5;
        end else begin
            stage6_out <= 16'b0;
        end
    end
end

// Pipeline Stage 7
reg [15:0] stage7_out;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage7_out <= 16'b0;
    end else if (mul_en_reg) begin
        if (mul_b_reg[6] == 1'b1) begin
            stage7_out <= {8'b0, mul_a_reg} << 6;
        end else begin
            stage7_out <= 16'b0;
        end
    end
end

// Pipeline Stage 8
reg [15:0] stage8_out;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage8_out <= 16'b0;
    end else if (mul_en_reg) begin
        if (mul_b_reg[7] == 1'b1) begin
            stage8_out <= {8'b0, mul_a_reg} << 7;
        end else begin
            stage8_out <= 16'b0;
        end
    end
end

// Final Addition Stage
reg [15:0] final_sum;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_sum <= 16'b0;
    end else if (mul_en_reg) begin
        final_sum <= stage1_out + stage2_out + stage3_out + stage4_out + stage5_out + stage6_out + stage7_out + stage8_out;
    end
end

// Output Stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end else if (mul_en_reg) begin
        mul_en_out <= 1'b1;
        mul_out <= final_sum;
    end else begin
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end
end

endmodule