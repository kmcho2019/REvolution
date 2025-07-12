module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg en_reg1, en_reg2, en_reg3;
    
    // Partial product array (8 rows x 16 columns)
    wire [15:0] pp [0:7];
    
    // Wallace Tree intermediate results
    reg [15:0] stage2_sum, stage2_carry;
    
    // Final adder result
    wire [15:0] final_sum;
    
    // Generate all partial products in parallel
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
        end
    endgenerate
    
    // Wallace Tree reduction (3:2 compressors)
    always @(*) begin
        // First level compression
        wire [15:0] sum1, carry1;
        compressor3_2 c1_0 (pp[0], pp[1], pp[2], sum1, carry1);
        
        wire [15:0] sum2, carry2;
        compressor3_2 c1_1 (pp[3], pp[4], pp[5], sum2, carry2);
        
        // Second level compression
        wire [15:0] sum3, carry3;
        compressor3_2 c2_0 (sum1, carry1 << 1, pp[6], sum3, carry3);
        
        wire [15:0] sum4, carry4;
        compressor3_2 c2_1 (sum2, carry2 << 1, pp[7], sum4, carry4);
        
        // Final compression before CPA
        stage2_sum = sum3 + sum4;
        stage2_carry = (carry3 << 1) + (carry4 << 1);
    end
    
    // Final carry-propagate adder
    assign final_sum = stage2_sum + stage2_carry;
    
    // Pipeline registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            en_reg1 <= 1'b0;
            en_reg2 <= 1'b0;
            en_reg3 <= 1'b0;
            stage2_sum <= 16'b0;
            stage2_carry <= 16'b0;
        end else begin
            // Stage 1: Input registration
            a_reg <= mul_a;
            b_reg <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: Wallace Tree results
            en_reg2 <= en_reg1;
            
            // Stage 3: Final result
            en_reg3 <= en_reg2;
        end
    end
    
    // Output assignments
    assign mul_en_out = en_reg3;
    assign mul_out = en_reg3 ? final_sum : 16'b0;
    
endmodule

// 3:2 compressor module (carry-save adder)
module compressor3_2 (
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule