module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Parameters for pipeline depth
parameter PIPELINE_DEPTH = 4;

// Input stage registers
reg [7:0] a_reg, b_reg;
reg en_pipeline[0:PIPELINE_DEPTH-1];

// Partial products
wire [15:0] pp [0:7];

// Generate all partial products
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pp_gen
        assign pp[i] = b_reg[i] ? {8'b0, a_reg} << i : 16'b0;
    end
endgenerate

// Pipeline stage registers
reg [15:0] stage1_sum [0:3];  // First adder level
reg [15:0] stage2_sum [0:1];  // Second adder level
reg [15:0] stage3_sum;        // Final adder

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_reg <= 8'b0;
        b_reg <= 8'b0;
        for (integer j = 0; j < PIPELINE_DEPTH; j = j + 1)
            en_pipeline[j] <= 1'b0;
            
        stage1_sum[0] <= 16'b0;
        stage1_sum[1] <= 16'b0;
        stage1_sum[2] <= 16'b0;
        stage1_sum[3] <= 16'b0;
        
        stage2_sum[0] <= 16'b0;
        stage2_sum[1] <= 16'b0;
        
        stage3_sum <= 16'b0;
        mul_out <= 16'b0;
    end
    else begin
        // Input stage
        en_pipeline[0] <= mul_en_in;
        if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end

        // Pipeline stage 1: First level additions
        en_pipeline[1] <= en_pipeline[0];
        stage1_sum[0] <= pp[0] + pp[1];
        stage1_sum[1] <= pp[2] + pp[3];
        stage1_sum[2] <= pp[4] + pp[5];
        stage1_sum[3] <= pp[6] + pp[7];

        // Pipeline stage 2: Second level additions
        en_pipeline[2] <= en_pipeline[1];
        stage2_sum[0] <= stage1_sum[0] + stage1_sum[1];
        stage2_sum[1] <= stage1_sum[2] + stage1_sum[3];

        // Pipeline stage 3: Final addition
        en_pipeline[3] <= en_pipeline[2];
        stage3_sum <= stage2_sum[0] + stage2_sum[1];

        // Output stage
        mul_en_out <= en_pipeline[3];
        mul_out <= stage3_sum;
    end
end

endmodule