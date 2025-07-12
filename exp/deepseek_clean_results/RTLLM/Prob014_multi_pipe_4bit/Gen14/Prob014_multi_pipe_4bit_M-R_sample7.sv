module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extend multiplicand (zero-pad MSBs)
wire [2*size-1:0] a_ext = {size{1'b0}, mul_a};

// Generate partial products using bitwise AND and shifts
wire [2*size-1:0] pp0 = mul_b[0] ? a_ext : 0;
wire [2*size-1:0] pp1 = mul_b[1] ? (a_ext << 1) : 0;
wire [2*size-1:0] pp2 = mul_b[2] ? (a_ext << 2) : 0;
wire [2*size-1:0] pp3 = mul_b[3] ? (a_ext << 3) : 0;

// Pipeline Stage 1: First level sums
reg [2*size-1:0] stage1_sum0, stage1_sum1;
wire [2*size-1:0] sum0 = pp0 + pp1;
wire [2*size-1:0] sum1 = pp2 + pp3;

// Pipeline Stage 2: Final sum
reg [2*size-1:0] stage2_sum;
wire [2*size-1:0] final_sum = stage1_sum0 + stage1_sum1;

// Pipeline registers with synchronous reset
always @(posedge clk) begin
    if (!rst_n) begin
        stage1_sum0 <= 0;
        stage1_sum1 <= 0;
        stage2_sum <= 0;
        mul_out <= 0;
    end else begin
        stage1_sum0 <= sum0;
        stage1_sum1 <= sum1;
        stage2_sum <= final_sum;
        mul_out <= stage2_sum;
    end
end

endmodule