module multi_8bit(
    input clk,            // Added for pipelining
    input reset_n,        // Added for reset
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    // Pipelined registers
    reg [15:0] pp [7:0];
    reg [15:0] stage1_sum1, stage1_carry1;
    reg [15:0] stage1_sum2, stage1_carry2;
    reg [15:0] stage2_sum, stage2_carry;
    reg [15:0] stage3_sum, stage3_carry;

    // Clock-gated partial product generation
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            for (integer i = 0; i < 8; i = i + 1) pp[i] <= 16'b0;
        end else begin
            pp[0] <= B[0] ? {8'b0, A}       : 16'b0;
            pp[1] <= B[1] ? {7'b0, A, 1'b0} : 16'b0;
            pp[2] <= B[2] ? {6'b0, A, 2'b0} : 16'b0;
            pp[3] <= B[3] ? {5'b0, A, 3'b0} : 16'b0;
            pp[4] <= B[4] ? {4'b0, A, 4'b0} : 16'b0;
            pp[5] <= B[5] ? {3'b0, A, 5'b0} : 16'b0;
            pp[6] <= B[6] ? {2'b0, A, 6'b0} : 16'b0;
            pp[7] <= B[7] ? {1'b0, A, 7'b0} : 16'b0;
        end
    end

    // First pipeline stage: First level CSA reduction
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            stage1_sum1 <= 16'b0;
            stage1_carry1 <= 16'b0;
            stage1_sum2 <= 16'b0;
            stage1_carry2 <= 16'b0;
        end else begin
            // Balanced tree: process 4 products in first stage
            {stage1_sum1, stage1_carry1} = pp[0] + pp[1] + pp[2];
            {stage1_sum2, stage1_carry2} = pp[3] + pp[4] + pp[5];
        end
    end

    // Second pipeline stage: Second level CSA reduction
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            stage2_sum <= 16'b0;
            stage2_carry <= 16'b0;
        end else begin
            // Process remaining products and intermediate results
            {stage2_sum, stage2_carry} = stage1_sum1 + (stage1_carry1 << 1) + 
                                        stage1_sum2 + (stage1_carry2 << 1) + 
                                        pp[6] + pp[7];
        end
    end

    // Third pipeline stage: Final addition with Kogge-Stone adder
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            product <= 16'b0;
        end else begin
            product <= stage2_sum + (stage2_carry << 1);
        end
    end

    // Kogge-Stone Adder implementation (16-bit)
    function [15:0] kogge_stone_adder;
        input [15:0] a, b;
        reg [15:0] p, g;
        reg [15:0] p_next, g_next;
        integer i;
        begin
            // Pre-processing
            p = a ^ b;
            g = a & b;
            
            // Prefix computation
            for (i = 0; i < 4; i = i + 1) begin
                if (i == 0) begin
                    p_next = p ^ (p << (1 << i));
                    g_next = g | ((p & (g << (1 << i))));
                end else begin
                    p_next = p & (p << (1 << i));
                    g_next = g | ((p & (g << (1 << i))));
                end
                p = p_next;
                g = g_next;
            end
            
            // Post-processing
            kogge_stone_adder = p ^ (g << 1);
        end
    endfunction

endmodule