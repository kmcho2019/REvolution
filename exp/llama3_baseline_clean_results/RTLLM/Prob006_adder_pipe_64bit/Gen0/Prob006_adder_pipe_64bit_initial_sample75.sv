module adder_pipe_64bit (
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
reg stage2_o_en;

// Stage 1: Register inputs and input enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage1_i_en <= 1'b0;
    end else if (i_en) begin
        stage1_adda <= adda;
        stage1_addb <= addb;
        stage1_i_en <= 1'b1;
    end else begin
        stage1_adda <= stage1_adda;
        stage1_addb <= stage1_addb;
        stage1_i_en <= stage1_i_en;
    end
end

// Stage 2: Perform addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum <= 64'd0;
        stage2_carry <= 64'd0;
        stage2_o_en <= 1'b0;
    end else if (stage1_i_en) begin
        {stage2_carry, stage2_sum} <= stage1_adda + stage1_addb;
        stage2_o_en <= 1'b1;
    end else begin
        stage2_sum <= stage2_sum;
        stage2_carry <= stage2_carry;
        stage2_o_en <= stage2_o_en;
    end
end

// Output logic
assign result = {1'b0, stage2_sum};
assign o_en = stage2_o_en;

endmodule