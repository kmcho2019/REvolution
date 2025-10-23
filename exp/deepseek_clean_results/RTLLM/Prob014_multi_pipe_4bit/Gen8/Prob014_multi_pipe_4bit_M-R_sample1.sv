module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Combinational partial products
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

// Pipeline Stage 2: Summation and Output
wire [7:0] sum_stage = pp0_reg + pp1_reg + pp2_reg + pp3_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= sum_stage;
    end
end

endmodule