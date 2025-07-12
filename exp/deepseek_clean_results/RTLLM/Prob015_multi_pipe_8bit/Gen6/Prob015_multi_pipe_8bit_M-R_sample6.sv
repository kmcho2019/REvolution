module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage 1 registers
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    
    // Pipeline stage 2 registers
    reg [15:0] stage2_result;
    reg stage2_en;
    
    // Explicit wire declarations for all intermediate signals
    wire [15:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;
    wire [15:0] sum_low, sum_high;
    wire [15:0] final_sum;
    
    // Partial product generation (combinational)
    assign pp0 = {8'b0, stage1_b[0] ? stage1_a : 8'b0};
    assign pp1 = {7'b0, stage1_b[1] ? stage1_a : 8'b0, 1'b0};
    assign pp2 = {6'b0, stage1_b[2] ? stage1_a : 8'b0, 2'b0};
    assign pp3 = {5'b0, stage1_b[3] ? stage1_a : 8'b0, 3'b0};
    assign pp4 = {4'b0, stage1_b[4] ? stage1_a : 8'b0, 4'b0};
    assign pp5 = {3'b0, stage1_b[5] ? stage1_a : 8'b0, 5'b0};
    assign pp6 = {2'b0, stage1_b[6] ? stage1_a : 8'b0, 6'b0};
    assign pp7 = {1'b0, stage1_b[7] ? stage1_a : 8'b0, 7'b0};
    
    // Parallel intermediate sums
    assign sum_low = pp0 + pp1 + pp2 + pp3;
    assign sum_high = pp4 + pp5 + pp6 + pp7;
    
    // Final sum calculation
    assign final_sum = sum_low + sum_high;
    
    // Output assignment with enable gating
    assign mul_out = stage2_en ? stage2_result : 16'b0;
    assign mul_en_out = stage2_en;

    // Pipeline stage 1 update (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
        end else begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;
        end
    end
    
    // Pipeline stage 2 update (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_result <= 16'b0;
            stage2_en <= 1'b0;
        end else begin
            stage2_result <= final_sum;
            stage2_en <= stage1_en;
        end
    end

endmodule