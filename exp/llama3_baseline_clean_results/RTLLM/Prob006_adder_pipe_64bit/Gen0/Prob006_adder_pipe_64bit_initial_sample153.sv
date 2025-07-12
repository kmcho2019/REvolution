module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] stage1_adda;
reg [63:0] stage1_addb;
reg [63:0] stage2_sum;
reg [64:0] stage3_result;
reg stage1_en;
reg stage2_en;
reg stage3_en;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_en <= 1'b0;
        stage2_en <= 1'b0;
        stage3_en <= 1'b0;
        o_en_reg <= 1'b0;
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage2_sum <= 64'd0;
        stage3_result <= 65'd0;
    end else begin
        stage1_en <= i_en;
        stage1_adda <= adda;
        stage1_addb <= addb;
        
        stage2_en <= stage1_en;
        if (stage1_en) begin
            stage2_sum <= adda + addb;
        end else begin
            stage2_sum <= 64'd0;
        end
        
        stage3_en <= stage2_en;
        if (stage2_en) begin
            stage3_result <= {1'b0, stage2_sum} + {{63{stage2_sum[63]}}, 1'b0};
        end else begin
            stage3_result <= 65'd0;
        end
        
        o_en_reg <= stage3_en;
    end
end

assign result = stage3_result;
assign o_en = o_en_reg;

endmodule