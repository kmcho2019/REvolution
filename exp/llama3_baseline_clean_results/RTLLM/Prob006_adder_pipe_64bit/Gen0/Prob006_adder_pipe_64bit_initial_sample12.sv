module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] stage1_sum;
reg [63:0] stage2_sum;
reg [0:0] stage1_carry;
reg [0:0] stage2_carry;
reg [63:0] stage1_adda;
reg [63:0] stage1_addb;
reg [63:0] stage2_adda;
reg [63:0] stage2_addb;
reg i_en_reg1;
reg i_en_reg2;
reg i_en_reg3;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum <= 64'd0;
        stage2_sum <= 64'd0;
        stage1_carry <= 1'd0;
        stage2_carry <= 1'd0;
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage2_adda <= 64'd0;
        stage2_addb <= 64'd0;
        i_en_reg1 <= 1'd0;
        i_en_reg2 <= 1'd0;
        i_en_reg3 <= 1'd0;
        o_en <= 1'd0;
    end else begin
        stage1_adda <= adda;
        stage1_addb <= addb;
        i_en_reg1 <= i_en;
        stage2_adda <= stage1_adda;
        stage2_addb <= stage1_addb;
        i_en_reg2 <= i_en_reg1;
        stage1_sum <= stage1_adda + stage1_addb;
        stage1_carry <= (stage1_adda[63] + stage1_addb[63] + 1'd0) > 1'd1;
        for (int i = 62; i >= 0; i--) begin
            stage1_sum[i] <= stage1_adda[i] + stage1_addb[i] + (i == 63 ? 1'd0 : (stage1_adda[i+1] + stage1_addb[i+1] + (i == 62 ? 1'd0 : (stage1_adda[i+2] + stage1_addb[i+2] + ... + stage1_adda[63] + stage1_addb[63]) > (1'd1 << (63-i)))) > 1'd1);
        end
        stage2_sum <= stage2_adda + stage2_addb + {63'd0, stage1_carry};
        o_en <= i_en_reg2;
        i_en_reg3 <= i_en_reg2;
    end
end

assign result = {stage2_sum[63], stage2_sum};

endmodule