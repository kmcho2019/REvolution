module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage registers
reg [15:0] stage1_a, stage1_b;
reg [15:0] stage2_a, stage2_b;
reg [15:0] stage3_a, stage3_b;
reg [15:0] stage4_a, stage4_b;

reg [16:0] sum1;  // Stage 1 sum (16 bits + carry)
reg [16:0] sum2;  // Stage 2 sum (16 bits + carry)
reg [16:0] sum3;  // Stage 3 sum (16 bits + carry)

reg carry1, carry2, carry3;

// Pipeline enable signals
reg en1, en2, en3, en4;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        stage1_a <= 16'b0;
        stage1_b <= 16'b0;
        stage2_a <= 16'b0;
        stage2_b <= 16'b0;
        stage3_a <= 16'b0;
        stage3_b <= 16'b0;
        stage4_a <= 16'b0;
        stage4_b <= 16'b0;
        
        sum1 <= 17'b0;
        sum2 <= 17'b0;
        sum3 <= 17'b0;
        
        carry1 <= 1'b0;
        carry2 <= 1'b0;
        carry3 <= 1'b0;
        
        en1 <= 1'b0;
        en2 <= 1'b0;
        en3 <= 1'b0;
        en4 <= 1'b0;
        
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 1 (bits 15:0)
        stage1_a <= adda[15:0];
        stage1_b <= addb[15:0];
        {carry1, sum1[15:0]} <= adda[15:0] + addb[15:0];
        sum1[16] <= carry1;
        en1 <= i_en;
        
        // Pipeline stage 2 (bits 31:16)
        stage2_a <= adda[31:16];
        stage2_b <= addb[31:16];
        {carry2, sum2[15:0]} <= stage2_a + stage2_b + carry1;
        sum2[16] <= carry2;
        en2 <= en1;
        
        // Pipeline stage 3 (bits 47:32)
        stage3_a <= adda[47:32];
        stage3_b <= addb[47:32];
        {carry3, sum3[15:0]} <= stage3_a + stage3_b + carry2;
        sum3[16] <= carry3;
        en3 <= en2;
        
        // Pipeline stage 4 (bits 63:48)
        stage4_a <= adda[63:48];
        stage4_b <= addb[63:48];
        en4 <= en3;
        
        // Final result assembly
        if (en4) begin
            result <= {1'b0, stage4_a} + {1'b0, stage4_b} + carry3;
            result[63:48] <= sum3[15:0];
            result[47:32] <= sum2[15:0];
            result[31:16] <= sum1[15:0];
            result[15:0] <= stage1_a + stage1_b;
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule