module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,  // Explicit 4-bit width
    input [3:0] mul_b,  // Explicit 4-bit width
    output reg [7:0] mul_out  // 8-bit output for 4x4 multiplication
);

// Pipeline registers
reg [7:0] stage1_sum;
reg [7:0] stage2_sum;

// First pipeline stage: Sum of first two partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum <= 8'b0;
    end else begin
        stage1_sum <= (mul_b[0] ? {4'b0, mul_a} : 8'b0) + 
                     (mul_b[1] ? {3'b0, mul_a, 1'b0} : 8'b0);
    end
end

// Second pipeline stage: Final sum and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        stage2_sum <= (mul_b[2] ? {2'b0, mul_a, 2'b0} : 8'b0) + 
                     (mul_b[3] ? {1'b0, mul_a, 3'b0} : 8'b0);
        mul_out <= stage1_sum + stage2_sum;
    end
end

endmodule