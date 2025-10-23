module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage 1: Input registration
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    
    // Pipeline stage 2: Partial products and intermediate sums
    reg [15:0] stage2_pp0_3, stage2_pp4_7;
    reg stage2_en;
    
    // Pipeline stage 3: Final result
    reg [15:0] stage3_result;
    reg stage3_en;
    
    // Generate partial products using shift-and-add approach
    wire [15:0] pp0 = {8'b0, stage1_b[0] ? stage1_a : 8'b0};
    wire [15:0] pp1 = {7'b0, stage1_b[1] ? stage1_a : 8'b0, 1'b0};
    wire [15:0] pp2 = {6'b0, stage1_b[2] ? stage1_a : 8'b0, 2'b0};
    wire [15:0] pp3 = {5'b0, stage1_b[3] ? stage1_a : 8'b0, 3'b0};
    wire [15:0] pp4 = {4'b0, stage1_b[4] ? stage1_a : 8'b0, 4'b0};
    wire [15:0] pp5 = {3'b0, stage1_b[5] ? stage1_a : 8'b0, 5'b0};
    wire [15:0] pp6 = {2'b0, stage1_b[6] ? stage1_a : 8'b0, 6'b0};
    wire [15:0] pp7 = {1'b0, stage1_b[7] ? stage1_a : 8'b0, 7'b0};
    
    // Intermediate sums
    wire [15:0] sum_pp0_3 = pp0 + pp1 + pp2 + pp3;
    wire [15:0] sum_pp4_7 = pp4 + pp5 + pp6 + pp7;
    
    // Final result calculation
    wire [15:0] final_sum = stage2_pp0_3 + stage2_pp4_7;
    
    // Pipeline register updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all pipeline registers
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
            
            stage2_pp0_3 <= 16'b0;
            stage2_pp4_7 <= 16'b0;
            stage2_en <= 1'b0;
            
            stage3_result <= 16'b0;
            stage3_en <= 1'b0;
        end else begin
            // Stage 1: Register inputs
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;
            
            // Stage 2: Register partial sums
            stage2_pp0_3 <= sum_pp0_3;
            stage2_pp4_7 <= sum_pp4_7;
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