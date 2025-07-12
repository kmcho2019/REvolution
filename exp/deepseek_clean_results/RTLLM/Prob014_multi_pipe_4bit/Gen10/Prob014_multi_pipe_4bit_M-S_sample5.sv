module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Pipeline stage 1: Partial products
reg [7:0] stage1;

// Pipeline stage 2: Final sum
reg [7:0] stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= 8'b0;
        stage2 <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        // Stage 1: Generate all partial products in parallel
        stage1 <= (mul_b[0] ? {4'b0, mul_a}       : 8'b0) +
                  (mul_b[1] ? {3'b0, mul_a, 1'b0}  : 8'b0) +
                  (mul_b[2] ? {2'b0, mul_a, 2'b0}  : 8'b0) +
                  (mul_b[3] ? {1'b0, mul_a, 3'b0}  : 8'b0);
                  
        // Stage 2: Pass through (already summed in stage1)
        stage2 <= stage1;
        
        // Output
        mul_out <= stage2;
    end
end

endmodule