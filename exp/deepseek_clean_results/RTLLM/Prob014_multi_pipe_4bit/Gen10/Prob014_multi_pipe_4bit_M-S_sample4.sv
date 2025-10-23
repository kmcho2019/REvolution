module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Pipeline registers
reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

// Partial products (computed directly)
wire [7:0] pp0 = mul_b[0] ? {4'b0, mul_a}       : 8'b0;
wire [7:0] pp1 = mul_b[1] ? {3'b0, mul_a, 1'b0} : 8'b0;
wire [7:0] pp2 = mul_b[2] ? {2'b0, mul_a, 2'b0} : 8'b0;
wire [7:0] pp3 = mul_b[3] ? {1'b0, mul_a, 3'b0} : 8'b0;

// Pipeline stage 1: First partial sum
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= 8'b0;
    end else begin
        stage1_reg <= pp0 + pp1;
    end
end

// Pipeline stage 2: Final sum and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_reg <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        stage2_reg <= stage1_reg + pp2 + pp3;
        mul_out <= stage2_reg;
    end
end

endmodule