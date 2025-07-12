module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Constants
localparam [2*size-1:0] ZERO = {2*size{1'b0}};

// Extended multiplicand with conditional shifts
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
wire [2*size-1:0] pp0 = mul_b[0] ? ext_a       : ZERO;
wire [2*size-1:0] pp1 = mul_b[1] ? (ext_a << 1) : ZERO;
wire [2*size-1:0] pp2 = mul_b[2] ? (ext_a << 2) : ZERO;
wire [2*size-1:0] pp3 = mul_b[3] ? (ext_a << 3) : ZERO;

// Pipeline registers
reg [2*size-1:0] stage1_reg;
reg [2*size-1:0] stage2_reg;

// Stage 1: pp0 + pp1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) stage1_reg <= ZERO;
    else stage1_reg <= pp0 + pp1;
end

// Stage 2: pp2 + pp3
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) stage2_reg <= ZERO;
    else stage2_reg <= pp2 + pp3;
end

// Final output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) mul_out <= ZERO;
    else mul_out <= stage1_reg + stage2_reg;
end

endmodule