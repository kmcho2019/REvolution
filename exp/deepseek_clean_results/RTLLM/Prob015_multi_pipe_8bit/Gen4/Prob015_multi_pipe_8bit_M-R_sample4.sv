module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline stage 0 registers
reg [7:0] stage0_a, stage0_b;
reg stage0_en;

// Pipeline stage 1 registers
reg [15:0] stage1_pp0, stage1_pp1, stage1_pp2, stage1_pp3;
reg [15:0] stage1_pp4, stage1_pp5, stage1_pp6, stage1_pp7;
reg stage1_en;

// Pipeline stage 2 registers
reg [15:0] stage2_sum1, stage2_sum2;
reg stage2_en;

// Pipeline stage 3 registers
reg [15:0] stage3_result;
reg stage3_en;

// Combinational partial products
wire [15:0] pp [7:0];
assign pp[0] = {8'b0, stage0_a} << 0;
assign pp[1] = {8'b0, stage0_a} << 1;
assign pp[2] = {8'b0, stage0_a} << 2;
assign pp[3] = {8'b0, stage0_a} << 3;
assign pp[4] = {8'b0, stage0_a} << 4;
assign pp[5] = {8'b0, stage0_a} << 5;
assign pp[6] = {8'b0, stage0_a} << 6;
assign pp[7] = {8'b0, stage0_a} << 7;

// Combinational sums
wire [15:0] sum1 = pp[0] + pp[1] + pp[2] + pp[3];
wire [15:0] sum2 = pp[4] + pp[5] + pp[6] + pp[7];
wire [15:0] final_sum = stage2_sum1 + stage2_sum2;

// Pipeline stage 0: Input sampling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage0_a <= 8'b0;
        stage0_b <= 8'b0;
        stage0_en <= 1'b0;
    end else begin
        stage0_a <= mul_a;
        stage0_b <= mul_b;
        stage0_en <= mul_en_in;
    end
end

// Pipeline stage 1: Partial product generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_pp0 <= 16'b0;
        stage1_pp1 <= 16'b0;
        stage1_pp2 <= 16'b0;
        stage1_pp3 <= 16'b0;
        stage1_pp4 <= 16'b0;
        stage1_pp5 <= 16'b0;
        stage1_pp6 <= 16'b0;
        stage1_pp7 <= 16'b0;
        stage1_en <= 1'b0;
    end else begin
        stage1_pp0 <= stage0_b[0] ? pp[0] : 16'b0;
        stage1_pp1 <= stage0_b[1] ? pp[1] : 16'b0;
        stage1_pp2 <= stage0_b[2] ? pp[2] : 16'b0;
        stage1_pp3 <= stage0_b[3] ? pp[3] : 16'b0;
        stage1_pp4 <= stage0_b[4] ? pp[4] : 16'b0;
        stage1_pp5 <= stage0_b[5] ? pp[5] : 16'b0;
        stage1_pp6 <= stage0_b[6] ? pp[6] : 16'b0;
        stage1_pp7 <= stage0_b[7] ? pp[7] : 16'b0;
        stage1_en <= stage0_en;
    end
end

// Pipeline stage 2: Intermediate sums
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum1 <= 16'b0;
        stage2_sum2 <= 16'b0;
        stage2_en <= 1'b0;
    end else begin
        stage2_sum1 <= stage1_pp0 + stage1_pp1 + stage1_pp2 + stage1_pp3;
        stage2_sum2 <= stage1_pp4 + stage1_pp5 + stage1_pp6 + stage1_pp7;
        stage2_en <= stage1_en;
    end
end

// Pipeline stage 3: Final sum and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_result <= 16'b0;
        stage3_en <= 1'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        stage3_result <= final_sum;
        stage3_en <= stage2_en;
        mul_out <= stage3_result;
        mul_en_out <= stage3_en;
    end
end

endmodule