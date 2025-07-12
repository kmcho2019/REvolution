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

reg [63:0] stage2_sum;
reg [63:0] stage2_carry;

reg [63:0] stage3_sum;
reg [63:0] stage3_carry;

reg stage4_o_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage1_i_en <= 1'd0;
    end else if (i_en) begin
        stage1_adda <= adda;
        stage1_addb <= addb;
        stage1_i_en <= 1'd1;
    end else begin
        stage1_adda <= stage1_adda;
        stage1_addb <= stage1_addb;
        stage1_i_en <= stage1_i_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_sum <= 64'd0;
        stage2_carry <= 64'd0;
    end else if (stage1_i_en) begin
        stage2_sum <= stage1_adda + stage1_addb;
        stage2_carry <= (stage1_adda[63] + stage1_addb[63] + (stage1_adda[62] + stage1_addb[62])[63])? 1 : 0;
    end else begin
        stage2_sum <= stage2_sum;
        stage2_carry <= stage2_carry;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage3_sum <= 64'd0;
        stage3_carry <= 64'd0;
    end else if (stage1_i_en) begin
        stage3_sum <= stage2_sum;
        stage3_carry <= stage2_carry;
    end else begin
        stage3_sum <= stage3_sum;
        stage3_carry <= stage3_carry;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage4_o_en <= 1'd0;
    end else if (stage1_i_en) begin
        stage4_o_en <= 1'd1;
    end else begin
        stage4_o_en <= stage4_o_en;
    end
end

always @(*) begin
    result <= {1'd0, stage3_sum};
    o_en <= stage4_o_en;
end

endmodule