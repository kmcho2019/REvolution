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
reg stage1_en;

reg [64:0] stage2_sum;
reg stage2_en;

reg [64:0] stage3_sum;
reg stage3_en;

reg [64:0] result_reg;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage1_en <= 1'b0;
    end else if (i_en) begin
        stage1_a <= adda;
        stage1_b <= addb;
        stage1_en <= 1'b1;
    end else begin
        stage1_a <= stage1_a;
        stage1_b <= stage1_b;
        stage1_en <= stage1_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_sum <= 65'd0;
        stage2_en <= 1'b0;
    end else if (stage1_en) begin
        {stage2_sum[64], stage2_sum[63:0]} <= {1'b0, stage1_a} + {1'b0, stage1_b};
        stage2_en <= 1'b1;
    end else begin
        stage2_sum <= stage2_sum;
        stage2_en <= stage2_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage3_sum <= 65'd0;
        stage3_en <= 1'b0;
    end else if (stage2_en) begin
        stage3_sum <= stage2_sum;
        stage3_en <= 1'b1;
    end else begin
        stage3_sum <= stage3_sum;
        stage3_en <= stage3_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (stage3_en) begin
        result_reg <= stage3_sum;
        o_en_reg <= 1'b1;
    end else begin
        result_reg <= result_reg;
        o_en_reg <= o_en_reg;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule