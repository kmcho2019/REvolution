module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] stage1_a;
reg [63:0] stage1_b;
reg stage1_en;

reg [64:0] stage2_sum;
reg stage2_en;

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
        stage2_sum <= {1'b0, stage1_a} + {1'b0, stage1_b};
        stage2_en <= 1'b1;
    end else begin
        stage2_sum <= stage2_sum;
        stage2_en <= stage2_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (stage2_en) begin
        result <= stage2_sum;
        o_en <= 1'b1;
    end else begin
        result <= result;
        o_en <= o_en;
    end
end

endmodule