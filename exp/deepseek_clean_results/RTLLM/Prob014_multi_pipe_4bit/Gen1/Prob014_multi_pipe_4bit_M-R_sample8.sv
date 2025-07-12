module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Extended inputs
wire [7:0] ext_a = {4'b0, mul_a};
wire [7:0] ext_b = {4'b0, mul_b};

// Partial products (direct assignments instead of generate)
wire [7:0] pp0 = mul_b[0] ? ext_a       : 8'd0;
wire [7:0] pp1 = mul_b[1] ? ext_a << 1  : 8'd0;
wire [7:0] pp2 = mul_b[2] ? ext_a << 2  : 8'd0;
wire [7:0] pp3 = mul_b[3] ? ext_a << 3  : 8'd0;

// Pipeline stage sums (continuous assignments)
wire [7:0] stage1_sum = pp0 + pp1;
wire [7:0] stage2_sum = pp2 + pp3;
wire [7:0] final_sum = stage1_sum + stage2_sum;

// Pipeline registers (combined into single always block)
reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= 8'd0;
        stage2_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        stage1_reg <= stage1_sum;
        stage2_reg <= stage2_sum;
        mul_out <= final_sum;
    end
end

endmodule