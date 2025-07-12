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
reg [64:0] stage1_sum;
reg [63:0] stage2_a;
reg [63:0] stage2_b;
reg [64:0] stage2_sum;
reg i_en_reg1;
reg i_en_reg2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage1_sum <= 65'd0;
        stage2_a <= 64'd0;
        stage2_b <= 64'd0;
        stage2_sum <= 65'd0;
        i_en_reg1 <= 1'b0;
        i_en_reg2 <= 1'b0;
        result <= 65'd0;
        o_en <= 1'b0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
        i_en_reg1 <= i_en;
        
        stage2_a <= stage1_a;
        stage2_b <= stage1_b;
        i_en_reg2 <= i_en_reg1;
        
        if (i_en_reg1) begin
            {stage1_sum[63:0], stage1_sum[64]} = stage1_a + stage1_b;
        end else begin
            stage1_sum <= 65'd0;
        end
        
        if (i_en_reg2) begin
            {stage2_sum[63:0], stage2_sum[64]} = stage2_a + stage2_b;
        end else begin
            stage2_sum <= 65'd0;
        end
        
        result <= stage2_sum;
        o_en <= i_en_reg2;
    end
end

endmodule