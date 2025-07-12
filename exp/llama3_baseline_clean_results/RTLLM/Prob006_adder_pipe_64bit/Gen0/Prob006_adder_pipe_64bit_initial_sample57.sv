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
reg stage1_i_en;

reg [63:0] stage2_adda;
reg [63:0] stage2_addb;
reg stage2_i_en;

reg [64:0] stage3_result;
reg stage3_o_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage1_i_en <= 1'b0;
        
        stage2_adda <= 64'd0;
        stage2_addb <= 64'd0;
        stage2_i_en <= 1'b0;
        
        stage3_result <= 65'd0;
        stage3_o_en <= 1'b0;
    end else if (i_en) begin
        stage1_adda <= adda;
        stage1_addb <= addb;
        stage1_i_en <= i_en;
        
        stage2_adda <= stage1_adda;
        stage2_addb <= stage1_addb;
        stage2_i_en <= stage1_i_en;
        
        if (stage2_i_en) begin
            {stage3_result[64], stage3_result[63:0]} <= {1'b0, stage2_adda} + {1'b0, stage2_addb};
            stage3_o_en <= stage2_i_en;
        end else begin
            stage3_result <= 65'd0;
            stage3_o_en <= 1'b0;
        end
    end else begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage1_i_en <= 1'b0;
        
        stage2_adda <= 64'd0;
        stage2_addb <= 64'd0;
        stage2_i_en <= 1'b0;
        
        stage3_result <= 65'd0;
        stage3_o_en <= 1'b0;
    end
end

assign result = stage3_result;
assign o_en = stage3_o_en;

endmodule