module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] stage1_a;
reg [63:0] stage1_b;
reg [63:0] stage2_sum;
reg [63:0] stage2_carry;
reg [63:0] stage3_sum;
reg [63:0] stage3_carry;
reg [63:0] stage4_sum;
reg [63:0] stage4_carry;
reg [64:0] final_sum;
reg o_en_reg;

assign result = final_sum;
assign o_en = o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage2_sum <= 64'd0;
        stage2_carry <= 1'b0;
        stage3_sum <= 64'd0;
        stage3_carry <= 1'b0;
        stage4_sum <= 64'd0;
        stage4_carry <= 1'b0;
        final_sum <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        if (i_en) begin
            stage1_a <= adda;
            stage1_b <= addb;
            o_en_reg <= 1'b0;
        end else begin
            stage1_a <= stage1_a;
            stage1_b <= stage1_b;
        end

        if (stage1_a!= 0 || stage1_b!= 0) begin
            {stage2_carry, stage2_sum} <= stage1_a + stage1_b;
            o_en_reg <= 1'b0;
        end else begin
            stage2_sum <= stage2_sum;
            stage2_carry <= stage2_carry;
        end

        if (stage2_sum!= 0 || stage2_carry!= 0) begin
            {stage3_carry, stage3_sum} <= {stage2_carry, stage2_sum} + {64'd0, stage2_carry};
            o_en_reg <= 1'b0;
        end else begin
            stage3_sum <= stage3_sum;
            stage3_carry <= stage3_carry;
        end

        if (stage3_sum!= 0 || stage3_carry!= 0) begin
            {stage4_carry, stage4_sum} <= {stage3_carry, stage3_sum} + {64'd0, stage3_carry};
            o_en_reg <= 1'b0;
        end else begin
            stage4_sum <= stage4_sum;
            stage4_carry <= stage4_carry;
        end

        if (stage4_sum!= 0 || stage4_carry!= 0) begin
            final_sum <= {stage4_carry, stage4_sum};
            o_en_reg <= 1'b1;
        end else begin
            final_sum <= final_sum;
            o_en_reg <= o_en_reg;
        end
    end
end

endmodule