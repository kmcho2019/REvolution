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

reg [63:0] stage2_a;
reg [63:0] stage2_b;
reg stage2_en;

reg [63:0] stage3_a;
reg [63:0] stage3_b;
reg stage3_en;

reg [64:0] sum;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_en <= 1'b0;
        stage2_en <= 1'b0;
        stage3_en <= 1'b0;
        o_en <= 1'b0;
    end else begin
        stage1_en <= i_en;
        stage2_en <= stage1_en;
        stage3_en <= stage2_en;
        o_en <= stage3_en;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage2_a <= 64'd0;
        stage2_b <= 64'd0;
        stage3_a <= 64'd0;
        stage3_b <= 64'd0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
        stage2_a <= stage1_a;
        stage2_b <= stage1_b;
        stage3_a <= stage2_a;
        stage3_b <= stage2_b;
    end
end

always @ (*) begin
    sum = stage3_a + stage3_b;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'd0;
    end else begin
        result <= sum;
    end
end

endmodule