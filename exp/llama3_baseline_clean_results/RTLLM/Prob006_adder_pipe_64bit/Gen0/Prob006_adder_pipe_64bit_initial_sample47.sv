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
reg [64:0] stage4_sum;
reg stage4_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage1_en <= 1'd0;
        stage2_sum <= 65'd0;
        stage2_en <= 1'd0;
        stage3_sum <= 65'd0;
        stage3_en <= 1'd0;
        stage4_sum <= 65'd0;
        stage4_en <= 1'd0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
        stage1_en <= i_en;
        stage2_sum <= {1'd0, stage1_a[63:0]} + {1'd0, stage1_b[63:0]};
        stage2_en <= stage1_en;
        stage3_sum <= stage2_sum;
        stage3_en <= stage2_en;
        stage4_sum <= stage3_sum;
        stage4_en <= stage3_en;
    end
end

assign result = stage4_sum;
assign o_en = stage4_en;

endmodule