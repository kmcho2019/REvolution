module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]    mul_a,
    input       [7:0]    mul_b,
    output reg          mul_en_out,
    output reg  [15:0]   mul_out
);

    // Pipeline registers
    reg [7:0] mul_a_reg, mul_b_reg;
    reg [7:0] pp [7:0];  // Partial products
    reg [15:0] stage1_sum;
    reg [15:0] stage2_sum;
    reg [15:0] stage3_sum;
    
    // Enable signal pipeline
    reg [3:0] en_pipe;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            en_pipe <= 4'b0;
            stage1_sum <= 16'b0;
            stage2_sum <= 16'b0;
            stage3_sum <= 16'b0;
            mul_out <= 16'b0;
        end
        else begin
            // Pipeline the enable signal
            en_pipe <= {en_pipe[2:0], mul_en_in};
            
            // Stage 0: Capture inputs
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            
            // Generate partial products (combinational)
            for (integer i = 0; i < 8; i = i + 1) begin
                pp[i] <= mul_b_reg[i] ? mul_a_reg : 8'b0;
            end
            
            // Stage 1: First level of addition
            stage1_sum <= 
                {8'b0, pp[0]} + 
                {7'b0, pp[1], 1'b0} + 
                {6'b0, pp[2], 2'b0};
            
            // Stage 2: Second level of addition
            stage2_sum <= 
                stage1_sum + 
                {5'b0, pp[3], 3'b0} + 
                {4'b0, pp[4], 4'b0};
            
            // Stage 3: Third level of addition
            stage3_sum <= 
                stage2_sum + 
                {3'b0, pp[5], 5'b0} + 
                {2'b0, pp[6], 6'b0};
            
            // Final stage: Complete the sum
            mul_out <= 
                stage3_sum + 
                {1'b0, pp[7], 7'b0};
        end
    end
    
    // Output enable is the last stage of enable pipeline
    always @* begin
        mul_en_out = en_pipe[3];
    end

endmodule