module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg [63:0] reg_sum;
reg [63:0] reg_carry;
reg [63:0] stage1_sum;
reg [63:0] stage1_carry;
reg [63:0] stage2_sum;
reg [63:0] stage2_carry;
reg [0:0] stage1_en;
reg [0:0] stage2_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        reg_sum <= 64'd0;
        reg_carry <= 64'd0;
        stage1_sum <= 64'd0;
        stage1_carry <= 64'd0;
        stage2_sum <= 64'd0;
        stage2_carry <= 64'd0;
        stage1_en <= 1'b0;
        stage2_en <= 1'b0;
        o_en <= 1'b0;
    end else if (i_en) begin
        reg_adda <= adda;
        reg_addb <= addb;
        stage1_en <= 1'b1;
    end else begin
        stage1_en <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_en <= 1'b0;
    end else if (stage1_en) begin
        stage2_en <= 1'b1;
    end else begin
        stage2_en <= 1'b0;
    end
end

always @(*) begin
    {reg_carry, stage1_sum} = reg_adda + reg_addb;
    {stage1_carry, stage2_sum} = stage1_sum + {64'd0, reg_carry};
    result = {stage1_carry, stage2_sum};
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en <= 1'b0;
    end else if (stage2_en) begin
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

endmodule