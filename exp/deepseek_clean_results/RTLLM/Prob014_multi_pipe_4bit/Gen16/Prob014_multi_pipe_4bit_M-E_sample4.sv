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
reg [2*size-1:0] stage1_reg;
reg [2*size-1:0] stage2_reg;

// Extended multiplicand
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

// Stage 1: Process bits 0-1
wire [2*size-1:0] stage1_sum = 
    (mul_b[0] ? ext_a : 0) +
    (mul_b[1] ? {ext_a[2*size-2:0], 1'b0} : 0);

// Stage 2: Process bits 2-3 and accumulate
wire [2*size-1:0] stage2_sum = 
    stage1_reg +
    (mul_b[2] ? {ext_a[2*size-3:0], 2'b0} : 0) +
    (mul_b[3] ? {ext_a[2*size-4:0], 3'b0} : 0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= 0;
        stage2_reg <= 0;
        mul_out <= 0;
    end else begin
        // Pipeline stage 1
        stage1_reg <= stage1_sum;
        
        // Pipeline stage 2
        stage2_reg <= stage2_sum;
        
        // Final output
        mul_out <= stage2_reg;
    end
end

endmodule