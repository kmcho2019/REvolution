module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Clock gating control
    wire clk_gated;
    assign clk_gated = clk & (mul_en_in | ~rst_n);

    // Pipeline stage 1: Input registration
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    
    // Pipeline stage 2: Partial products generation
    reg [15:0] stage2_pp [0:7];
    reg stage2_en;
    
    // Pipeline stage 3: Carry-save intermediate sums
    reg [15:0] stage3_sum0, stage3_sum1;
    reg [15:0] stage3_carry;
    reg stage3_en;
    
    // Pipeline stage 4: Final accumulation
    reg [15:0] stage4_result;
    reg stage4_en;
    
    // Generate partial products more efficiently
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            always @(posedge clk_gated or negedge rst_n) begin
                if (!rst_n) begin
                    stage2_pp[i] <= 16'b0;
                end else if (mul_en_in) begin
                    stage2_pp[i] <= (mul_b[i] ? {8'b0, mul_a} << i : 16'b0);
                end
            end
        end
    endgenerate
    
    // Carry-save addition for partial products
    wire [15:0] sum_pp0_3 = stage2_pp[0] + stage2_pp[1] + stage2_pp[2];
    wire [15:0] sum_pp4_7 = stage2_pp[4] + stage2_pp[5] + stage2_pp[6];
    wire [15:0] carry_pp0_3 = (stage2_pp[0] & stage2_pp[1]) | 
                             (stage2_pp[0] & stage2_pp[2]) | 
                             (stage2_pp[1] & stage2_pp[2]);
    wire [15:0] carry_pp4_7 = (stage2_pp[4] & stage2_pp[5]) | 
                             (stage2_pp[4] & stage2_pp[6]) | 
                             (stage2_pp[5] & stage2_pp[6]);
    
    // Final result calculation
    wire [15:0] final_sum = stage3_sum0 + stage3_sum1 + stage3_carry + stage2_pp[3] + stage2_pp[7];
    
    // Pipeline register updates
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all pipeline registers
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
            
            stage2_en <= 1'b0;
            
            stage3_sum0 <= 16'b0;
            stage3_sum1 <= 16'b0;
            stage3_carry <= 16'b0;
            stage3_en <= 1'b0;
            
            stage4_result <= 16'b0;
            stage4_en <= 1'b0;
        end else if (mul_en_in) begin
            // Stage 1: Register inputs
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;
            
            // Stage 2: Partial products already registered in generate block
            stage2_en <= stage1_en;
            
            // Stage 3: Register intermediate sums
            stage3_sum0 <= sum_pp0_3;
            stage3_sum1 <= sum_pp4_7;
            stage3_carry <= carry_pp0_3 | (carry_pp4_7 << 4);
            stage3_en <= stage2_en;
            
            // Stage 4: Register final result
            stage4_result <= final_sum;
            stage4_en <= stage3_en;
        end
    end
    
    // Output assignments
    assign mul_en_out = stage4_en;
    assign mul_out = stage4_en ? stage4_result : 16'b0;

endmodule