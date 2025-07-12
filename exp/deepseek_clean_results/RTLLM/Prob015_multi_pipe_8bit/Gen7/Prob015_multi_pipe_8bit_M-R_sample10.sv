module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline registers
reg [7:0] stage1_a, stage1_b;
reg stage1_en;
reg [15:0] stage2_sum1, stage2_sum2;
reg stage2_en;
reg stage3_en;

// Partial products wires
wire [15:0] pp0 = stage1_b[0] ? {8'b0, stage1_a} : 16'b0;
wire [15:0] pp1 = stage1_b[1] ? {7'b0, stage1_a, 1'b0} : 16'b0;
wire [15:0] pp2 = stage1_b[2] ? {6'b0, stage1_a, 2'b0} : 16'b0;
wire [15:0] pp3 = stage1_b[3] ? {5'b0, stage1_a, 3'b0} : 16'b0;
wire [15:0] pp4 = stage1_b[4] ? {4'b0, stage1_a, 4'b0} : 16'b0;
wire [15:0] pp5 = stage1_b[5] ? {3'b0, stage1_a, 5'b0} : 16'b0;
wire [15:0] pp6 = stage1_b[6] ? {2'b0, stage1_a, 6'b0} : 16'b0;
wire [15:0] pp7 = stage1_b[7] ? {1'b0, stage1_a, 7'b0} : 16'b0;

// First stage of addition (balanced tree)
wire [15:0] sum1 = pp0 + pp1;
wire [15:0] sum2 = pp2 + pp3;
wire [15:0] sum3 = pp4 + pp5;
wire [15:0] sum4 = pp6 + pp7;

// Pipeline stage 1: Input sampling
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 8'b0;
        stage1_b <= 8'b0;
        stage1_en <= 1'b0;
    end else begin
        stage1_en <= mul_en_in;
        if (mul_en_in) begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
        end
    end
end

// Pipeline stage 2: Intermediate sums
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum1 <= 16'b0;
        stage2_sum2 <= 16'b0;
        stage2_en <= 1'b0;
    end else begin
        stage2_sum1 <= sum1 + sum2;
        stage2_sum2 <= sum3 + sum4;
        stage2_en <= stage1_en;
    end
end

// Pipeline stage 3: Final sum and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
        stage3_en <= 1'b0;
    end else begin
        mul_out <= stage2_sum1 + stage2_sum2;
        mul_en_out <= stage2_en;
        stage3_en <= stage2_en;
    end
end

endmodule