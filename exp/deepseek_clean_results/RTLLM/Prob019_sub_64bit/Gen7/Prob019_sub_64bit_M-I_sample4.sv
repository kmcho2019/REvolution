module sub_64bit (
    input clk,
    input clk_en,
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Pipeline registers with clock gating
    reg signed [31:0] A_low, B_low;
    reg signed [31:0] A_high, B_high;
    reg [32:0] stage1_result; // Extra bit for carry
    reg stage1_overflow;
    
    // Final result register
    reg signed [63:0] result_reg;
    reg overflow_reg;

    // Stage 1: Split into 32-bit operations
    always @(posedge clk) if (clk_en) begin
        A_low <= A[31:0];
        B_low <= B[31:0];
        A_high <= A[63:32];
        B_high <= B[63:32];
    end

    // Stage 2: Perform 32-bit subtraction with carry
    always @(posedge clk) if (clk_en) begin
        {stage1_result[32], stage1_result[31:0]} = {1'b0, A_low} - {1'b0, B_low};
        stage1_overflow <= (A_low[31] ^ B_low[31]) && (A_low[31] ^ stage1_result[31]);
    end

    // Stage 3: Complete 64-bit operation and final overflow check
    always @(posedge clk) if (clk_en) begin
        result_reg <= {A_high - B_high - stage1_result[32], stage1_result[31:0]};
        
        // Final overflow detection considers both stages
        overflow_reg <= ((A_high[31] ^ B_high[31]) && (A_high[31] ^ result_reg[63])) || 
                       stage1_overflow;
    end

    assign result = result_reg;
    assign overflow = overflow_reg;

endmodule