module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage registers
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    
    // Partial product array (8 rows x 16 columns)
    reg [15:0] stage2_pp [0:7];
    reg stage2_en;
    
    // Wallace Tree intermediate results
    reg [15:0] stage3_sum, stage3_carry;
    reg stage3_en;
    
    // Final result register
    reg [15:0] final_result;
    reg final_en;
    
    // Generate all partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            always @(*) begin
                stage2_pp[i] = stage1_b[i] ? ({8'b0, stage1_a} << i) : 16'b0;
            end
        end
    endgenerate
    
    // Wallace Tree compression (using 4:2 compressors)
    wire [15:0] level1_sum [0:3];
    wire [15:0] level1_carry [0:3];
    
    // First level compression (8 -> 4)
    compressor_4to2 comp0 (
        .in0(stage2_pp[0]),
        .in1(stage2_pp[1]),
        .in2(stage2_pp[2]),
        .in3(stage2_pp[3]),
        .sum(level1_sum[0]),
        .carry(level1_carry[0])
    );
    
    compressor_4to2 comp1 (
        .in0(stage2_pp[4]),
        .in1(stage2_pp[5]),
        .in2(stage2_pp[6]),
        .in3(stage2_pp[7]),
        .sum(level1_sum[1]),
        .carry(level1_carry[1])
    );
    
    // Second level compression (4 -> 2)
    wire [15:0] level2_sum, level2_carry;
    
    compressor_4to2 comp2 (
        .in0(level1_sum[0]),
        .in1(level1_carry[0]),
        .in2(level1_sum[1]),
        .in3(level1_carry[1]),
        .sum(level2_sum),
        .carry(level2_carry)
    );
    
    // Final addition
    wire [15:0] final_sum = level2_sum + level2_carry;
    
    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all pipeline registers
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
            
            stage2_en <= 1'b0;
            
            stage3_sum <= 16'b0;
            stage3_carry <= 16'b0;
            stage3_en <= 1'b0;
            
            final_result <= 16'b0;
            final_en <= 1'b0;
        end else begin
            // Stage 1: Register inputs
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;
            
            // Stage 2: Partial products are generated combinationally
            stage2_en <= stage1_en;
            
            // Stage 3: Register compressed sums
            stage3_sum <= level2_sum;
            stage3_carry <= level2_carry;
            stage3_en <= stage2_en;
            
            // Final stage: Register final result
            final_result <= final_sum;
            final_en <= stage3_en;
        end
    end
    
    // Output assignments
    assign mul_en_out = final_en;
    assign mul_out = final_en ? final_result : 16'b0;

endmodule

// 4:2 Compressor module
module compressor_4to2 (
    input wire [15:0] in0,
    input wire [15:0] in1,
    input wire [15:0] in2,
    input wire [15:0] in3,
    output wire [15:0] sum,
    output wire [15:0] carry
);
    // Implement carry-save addition
    wire [15:0] sum1 = in0 ^ in1;
    wire [15:0] carry1 = in0 & in1;
    
    wire [15:0] sum2 = sum1 ^ in2;
    wire [15:0] carry2 = sum1 & in2;
    
    assign sum = sum2 ^ in3;
    assign carry = {carry1[14:0], 1'b0} + {carry2[14:0], 1'b0} + (sum2 & in3);
endmodule