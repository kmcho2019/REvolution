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
reg [64:0] stage1_sum;

reg [63:0] stage2_a;
reg [63:0] stage2_b;
reg stage2_en;
reg [64:0] stage2_sum;

reg [64:0] sum;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 0;
        stage1_b <= 0;
        stage1_en <= 0;
        stage1_sum <= 0;
        stage2_a <= 0;
        stage2_b <= 0;
        stage2_en <= 0;
        stage2_sum <= 0;
        sum <= 0;
        o_en_reg <= 0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
        stage1_en <= i_en;
        
        stage2_a <= stage1_a;
        stage2_b <= stage1_b;
        stage2_en <= stage1_en;
        
        sum <= stage2_a + stage2_b;
        o_en_reg <= stage2_en;
    end
end

always @(*) begin
    result = sum;
    o_en = o_en_reg;
end

endmodule