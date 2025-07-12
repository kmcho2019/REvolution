module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Single pipeline register
reg [2*size-1:0] stage1_sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum <= 0;
        mul_out <= 0;
    end else begin
        // First stage: bits 0-1
        stage1_sum <= (mul_b[0] ? mul_a : 0) + 
                     (mul_b[1] ? (mul_a << 1) : 0);
        
        // Second stage: combine with bits 2-3 and output
        mul_out <= stage1_sum + 
                  (mul_b[2] ? (mul_a << 2) : 0) + 
                  (mul_b[3] ? (mul_a << 3) : 0);
    end
end

endmodule