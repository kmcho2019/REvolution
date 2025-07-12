module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Partial products generation (combinational)
wire [7:0] pp0 = mul_b[0] ? {4'b0, mul_a}       : 8'b0;
wire [7:0] pp1 = mul_b[1] ? {3'b0, mul_a, 1'b0} : 8'b0;
wire [7:0] pp2 = mul_b[2] ? {2'b0, mul_a, 2'b0} : 8'b0;
wire [7:0] pp3 = mul_b[3] ? {1'b0, mul_a, 3'b0} : 8'b0;

// Pipeline Stage 1: Partial Product Registers
reg [7:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp0_reg <= 8'b0;
        pp1_reg <= 8'b0;
        pp2_reg <= 8'b0;
        pp3_reg <= 8'b0;
    end else begin
        pp0_reg <= pp0;
        pp1_reg <= pp1;
        pp2_reg <= pp2;
        pp3_reg <= pp3;
    end
end

// Intermediate sums (combinational)
wire [7:0] sum_stage1 = pp0_reg + pp1_reg;
wire [7:0] sum_stage2 = pp2_reg + pp3_reg;

// Pipeline Stage 2: Sum Registers
reg [7:0] sum1_reg, sum2_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1_reg <= 8'b0;
        sum2_reg <= 8'b0;
    end else begin
        sum1_reg <= sum_stage1;
        sum2_reg <= sum_stage2;
    end
end

// Final output calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= sum1_reg + sum2_reg;
    end
end

endmodule