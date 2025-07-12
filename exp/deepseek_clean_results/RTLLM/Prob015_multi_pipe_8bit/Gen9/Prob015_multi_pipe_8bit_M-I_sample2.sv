module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Clock gating logic
    wire clk_gated;
    assign clk_gated = clk & (mul_en_in | ~rst_n);

    // Pipeline stage 1: Input registration
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    
    // Pipeline stage 2: Carry-save partial products
    reg [15:0] stage2_sum, stage2_carry;
    reg stage2_en;
    
    // Pipeline stage 3: Final result
    reg [15:0] stage3_result;
    reg stage3_en;
    
    // Generate partial products using optimized shift-and-add
    wire [15:0] pp [0:7];
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = stage1_b[i] ? ({8'b0, stage1_a} << i) : 16'b0;
        end
    endgenerate
    
    // Carry-save addition for first 4 partial products
    wire [15:0] sum_pp0_3, carry_pp0_3;
    assign {carry_pp0_3, sum_pp0_3} = pp[0] + pp[1] + pp[2] + pp[3];
    
    // Carry-save addition for last 4 partial products
    wire [15:0] sum_pp4_7, carry_pp4_7;
    assign {carry_pp4_7, sum_pp4_7} = pp[4] + pp[5] + pp[6] + pp[7];
    
    // Final result calculation
    wire [15:0] final_sum = stage2_sum + stage2_carry;
    
    // Pipeline register updates
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all pipeline registers
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
            
            stage2_sum <= 16'b0;
            stage2_carry <= 16'b0;
            stage2_en <= 1'b0;
            
            stage3_result <= 16'b0;
            stage3_en <= 1'b0;
        end else begin
            // Stage 1: Register inputs
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;
            
            // Stage 2: Register carry-save sums
            stage2_sum <= sum_pp0_3 + sum_pp4_7;
            stage2_carry <= carry_pp0_3 + carry_pp4_7;
            stage2_en <= stage1_en;
            
            // Stage 3: Register final result
            stage3_result <= final_sum;
            stage3_en <= stage2_en;
        end
    end
    
    // Output assignments
    assign mul_en_out = stage3_en;
    assign mul_out = stage3_en ? stage3_result : 16'b0;

endmodule