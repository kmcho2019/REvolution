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
    
    // Pipeline stage 2: Partial products with carry-save adders
    reg [15:0] stage2_sum, stage2_carry;
    reg stage2_en;
    
    // Pipeline stage 3: Final result
    reg [15:0] stage3_result;
    reg stage3_en;
    
    // Carry-save partial product generation
    wire [15:0] pp0 = {8'b0, stage1_b[0] ? stage1_a : 8'b0};
    wire [15:0] pp1 = {7'b0, stage1_b[1] ? stage1_a : 8'b0, 1'b0};
    wire [15:0] pp2 = {6'b0, stage1_b[2] ? stage1_a : 8'b0, 2'b0};
    wire [15:0] pp3 = {5'b0, stage1_b[3] ? stage1_a : 8'b0, 3'b0};
    
    // First level carry-save addition
    wire [15:0] sum01 = pp0 ^ pp1;
    wire [15:0] carry01 = (pp0 & pp1) << 1;
    
    wire [15:0] sum23 = pp2 ^ pp3;
    wire [15:0] carry23 = (pp2 & pp3) << 1;
    
    // Second level carry-save addition
    wire [15:0] sum0123 = sum01 ^ sum23;
    wire [15:0] carry0123 = (sum01 & sum23) << 1;
    
    // Upper partial products
    wire [15:0] pp4 = {4'b0, stage1_b[4] ? stage1_a : 8'b0, 4'b0};
    wire [15:0] pp5 = {3'b0, stage1_b[5] ? stage1_a : 8'b0, 5'b0};
    wire [15:0] pp6 = {2'b0, stage1_b[6] ? stage1_a : 8'b0, 6'b0};
    wire [15:0] pp7 = {1'b0, stage1_b[7] ? stage1_a : 8'b0, 7'b0};
    
    // Upper carry-save addition
    wire [15:0] sum45 = pp4 ^ pp5;
    wire [15:0] carry45 = (pp4 & pp5) << 1;
    
    wire [15:0] sum67 = pp6 ^ pp7;
    wire [15:0] carry67 = (pp6 & pp7) << 1;
    
    // Final carry-save addition for upper bits
    wire [15:0] sum4567 = sum45 ^ sum67;
    wire [15:0] carry4567 = (sum45 & sum67) << 1;
    
    // Final result calculation
    wire [15:0] final_sum = stage2_sum + stage2_carry;
    
    // Pipeline register updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
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
            stage2_sum <= sum0123 ^ sum4567;
            stage2_carry <= (carry0123 + carry4567) << 1;
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