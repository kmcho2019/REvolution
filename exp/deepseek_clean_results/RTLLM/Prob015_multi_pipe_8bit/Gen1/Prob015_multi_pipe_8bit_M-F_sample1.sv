module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] mul_a_reg, mul_b_reg;
    reg [15:0] pp [0:7];  // Partial products (extended to 16 bits with proper shifting)
    reg [15:0] stage1_sum [0:3];
    reg [15:0] stage2_sum [0:1];
    reg [15:0] final_sum;
    
    // Enable pipeline - one register per stage
    reg [3:0] en_pipe;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            for (integer i = 0; i < 8; i = i+1) pp[i] <= 16'b0;
            for (integer i = 0; i < 4; i = i+1) stage1_sum[i] <= 16'b0;
            for (integer i = 0; i < 2; i = i+1) stage2_sum[i] <= 16'b0;
            final_sum <= 16'b0;
            en_pipe <= 4'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end
        else begin
            // Pipeline the enable signal through all stages
            en_pipe <= {en_pipe[2:0], mul_en_in};
            
            // Stage 0: Register inputs and generate partial products
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            
            // Generate partial products (registered)
            for (integer i = 0; i < 8; i = i+1) begin
                pp[i] <= mul_b_reg[i] ? {8'b0, mul_a_reg} << i : 16'b0;
            end
            
            // Stage 1: First level of addition (8→4)
            if (en_pipe[0]) begin
                stage1_sum[0] <= pp[0] + pp[1];
                stage1_sum[1] <= pp[2] + pp[3];
                stage1_sum[2] <= pp[4] + pp[5];
                stage1_sum[3] <= pp[6] + pp[7];
            end
            
            // Stage 2: Second level of addition (4→2)
            if (en_pipe[1]) begin
                stage2_sum[0] <= stage1_sum[0] + stage1_sum[1];
                stage2_sum[1] <= stage1_sum[2] + stage1_sum[3];
            end
            
            // Stage 3: Final addition and output
            if (en_pipe[2]) begin
                final_sum <= stage2_sum[0] + stage2_sum[1];
                mul_out <= final_sum;
            end
            
            // Output enable is the last stage of the enable pipeline
            mul_en_out <= en_pipe[3];
        end
    end

endmodule