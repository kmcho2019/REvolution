module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Extended multiplicand with zero padding
wire [7:0] ext_a = {4'b0, mul_a};

// Partial products
wire [7:0] pp0 = mul_b[0] ? ext_a : 8'b0;
wire [7:0] pp1 = mul_b[1] ? (ext_a << 1) : 8'b0;
wire [7:0] pp2 = mul_b[2] ? (ext_a << 2) : 8'b0;
wire [7:0] pp3 = mul_b[3] ? (ext_a << 3) : 8'b0;

// Pipeline registers
reg [7:0] stage1_reg, stage2_reg;

// Combinational sums
wire [7:0] sum_stage1 = pp0 + pp1;
wire [7:0] sum_stage2 = stage1_reg + pp2 + pp3;

// Sequential pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= 8'b0;
        stage2_reg <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        stage1_reg <= sum_stage1;
        stage2_reg <= sum_stage2;
        mul_out <= stage2_reg;
    end
end

endmodule