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

reg [63:0] stage3_adda;
reg [63:0] stage3_addb;
reg stage3_i_en;

reg [64:0] sum;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage1_i_en <= 1'd0;
        
        stage2_adda <= 64'd0;
        stage2_addb <= 64'd0;
        stage2_i_en <= 1'd0;
        
        stage3_adda <= 64'd0;
        stage3_addb <= 64'd0;
        stage3_i_en <= 1'd0;
        
        sum <= 65'd0;
        o_en_reg <= 1'd0;
    end else begin
        if (i_en) begin
            stage1_adda <= adda;
            stage1_addb <= addb;
            stage1_i_en <= 1'd1;
        end else begin
            stage1_adda <= stage1_adda;
            stage1_addb <= stage1_addb;
            stage1_i_en <= stage1_i_en;
        end
        
        stage2_adda <= stage1_adda;
        stage2_addb <= stage1_addb;
        stage2_i_en <= stage1_i_en;
        
        stage3_adda <= stage2_adda;
        stage3_addb <= stage2_addb;
        stage3_i_en <= stage2_i_en;
        
        if (stage3_i_en) begin
            sum <= {1'd0, stage3_adda} + {1'd0, stage3_addb};
            o_en_reg <= 1'd1;
        end else begin
            sum <= sum;
            o_en_reg <= 1'd0;
        end
    end
end

assign result = sum;
assign o_en = o_en_reg;

endmodule