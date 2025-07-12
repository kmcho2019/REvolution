module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] stage1_adda;
reg [63:0] stage1_addb;
reg stage1_en;

reg [64:0] stage2_sum;
reg stage2_en;

reg [64:0] stage3_sum;
reg stage3_en;

reg [64:0] stage4_sum;
reg stage4_en;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage1_en <= 1'b0;
        
        stage2_sum <= 65'd0;
        stage2_en <= 1'b0;
        
        stage3_sum <= 65'd0;
        stage3_en <= 1'b0;
        
        stage4_sum <= 65'd0;
        stage4_en <= 1'b0;
        
        result <= 65'd0;
        o_en <= 1'b0;
    end else begin
        stage1_adda <= adda;
        stage1_addb <= addb;
        stage1_en <= i_en;
        
        stage2_sum <= {1'b0, stage1_adda} + {1'b0, stage1_addb};
        stage2_en <= stage1_en;
        
        stage3_sum <= stage2_sum;
        stage3_en <= stage2_en;
        
        stage4_sum <= stage3_sum;
        stage4_en <= stage3_en;
        
        result <= stage4_sum;
        o_en <= stage4_en;
    end
end

endmodule