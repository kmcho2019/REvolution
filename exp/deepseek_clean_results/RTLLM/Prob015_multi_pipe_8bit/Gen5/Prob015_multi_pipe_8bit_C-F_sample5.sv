module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    
    // Pipeline stage 2 registers
    reg [15:0] stage2_result;
    reg stage2_en;
    
    // Partial products (optimized shift-and-add)
    wire [15:0] pp0 = {8'b0, stage1_b[0] ? stage1_a : 8'b0};
    wire [15:0] pp1 = {7'b0, stage1_b[1] ? stage1_a : 8'b0, 1'b0};
    wire [15:0] pp2 = {6'b0, stage1_b[2] ? stage1_a : 8'b0, 2'b0};
    wire [15:0] pp3 = {5'b0, stage1_b[3] ? stage1_a : 8'b0, 3'b0};
    wire [15:0] pp4 = {4'b0, stage1_b[4] ? stage1_a : 8'b0, 4'b0};
    wire [15:0] pp5 = {3'b0, stage1_b[5] ? stage1_a : 8'b0, 5'b0};
    wire [15:0] pp6 = {2'b0, stage1_b[6] ? stage1_a : 8'b0, 6'b0};
    wire [15:0] pp7 = {1'b0, stage1_b[7] ? stage1_a : 8'b0, 7'b0};
    
    // Parallel intermediate sums (optimized from Example 1)
    wire [15:0] sum_low = pp0 + pp1 + pp2 + pp3;
    wire [15:0] sum_high = pp4 + pp5 + pp6 + pp7;
    
    // Final sum calculation
    wire [15:0] final_sum = sum_low + sum_high;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all registers
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
            
            stage2_result <= 16'b0;
            stage2_en <= 1'b0;
            
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Register inputs and enable
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;
            
            // Stage 2: Register final result and enable
            stage2_result <= final_sum;
            stage2_en <= stage1_en;
            
            // Output with enable gating
            mul_en_out <= stage2_en;
            mul_out <= stage2_en ? stage2_result : 16'b0;
        end
    end

endmodule