module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] stage1_sum;
reg [2*size-1:0] stage2_sum;

// First pipeline stage: Sum of first two partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum <= {2*size{1'b0}};
    end else begin
        stage1_sum <= (mul_b[0] ? mul_a : 0) + 
                     (mul_b[1] ? (mul_a << 1) : 0);
    end
end

// Second pipeline stage: Final sum and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        stage2_sum <= (mul_b[2] ? (mul_a << 2) : 0) + 
                     (mul_b[3] ? (mul_a << 3) : 0);
        mul_out <= stage1_sum + stage2_sum;
    end
end

endmodule