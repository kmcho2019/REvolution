module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Constants
localparam size = 4;

// Input extension
wire [7:0] a_ext = {4'b0, mul_a};
wire [7:0] b_ext = {4'b0, mul_b};

// Partial products (combinational)
wire [7:0] pp0 = b_ext[0] ? a_ext : 8'b0;
wire [7:0] pp1 = b_ext[1] ? (a_ext << 1) : 8'b0;
wire [7:0] pp2 = b_ext[2] ? (a_ext << 2) : 8'b0;
wire [7:0] pp3 = b_ext[3] ? (a_ext << 3) : 8'b0;

// Pipeline stage 1 registers
reg [7:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;

// Stage 1: Register partial products
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
wire [7:0] sum0 = pp0_reg + pp1_reg;
wire [7:0] sum1 = pp2_reg + pp3_reg;

// Pipeline stage 2 registers
reg [7:0] sum0_reg, sum1_reg;

// Stage 2: Register intermediate sums
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0_reg <= 8'b0;
        sum1_reg <= 8'b0;
    end else begin
        sum0_reg <= sum0;
        sum1_reg <= sum1;
    end
end

// Final output calculation
wire [7:0] final_sum = sum0_reg + sum1_reg;

// Output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        mul_out <= 8'b0;
    else
        mul_out <= final_sum;
end

endmodule