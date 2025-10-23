module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline control signals
    reg stage1_valid, stage2_valid;
    wire zero_operand = (mul_a == 8'b0) || (mul_b == 8'b0);
    
    // Stage 1 registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp [7:0];
    reg [15:0] stage1_sum [3:0];
    
    // Stage 2 registers
    reg [15:0] compressed_sum [1:0];
    reg [15:0] final_result;
    
    // Generate partial products
    always @(*) begin
        if (stage1_valid) begin
            for (integer i = 0; i < 8; i++) begin
                pp[i] = b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
            end
        end
    end
    
    // First stage compression (Wallace Tree level 1)
    always @(*) begin
        if (stage1_valid) begin
            // First level of 3:2 compressors
            stage1_sum[0] = pp[0] + pp[1] + pp[2];
            stage1_sum[1] = pp[3] + pp[4] + pp[5];
            stage1_sum[2] = pp[6] + pp[7];
            stage1_sum[3] = 16'b0; // Unused in this compression level
        end
    end
    
    // Second stage compression (Wallace Tree level 2)
    always @(*) begin
        if (stage2_valid) begin
            compressed_sum[0] = stage1_sum[0] + stage1_sum[1];
            compressed_sum[1] = stage1_sum[2];
        end
    end
    
    // Pipeline control and data flow
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            stage1_valid <= 1'b0;
            stage2_valid <= 1'b0;
            final_result <= 16'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 0: Input sampling
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end
            
            // Stage 1: Partial product generation and initial compression
            stage1_valid <= mul_en_in && !zero_operand;
            
            // Stage 2: Final compression and addition
            stage2_valid <= stage1_valid;
            if (stage2_valid) begin
                final_result <= compressed_sum[0] + compressed_sum[1];
            end else if (zero_operand && mul_en_in) begin
                final_result <= 16'b0; // Early zero result
            end
            
            // Output
            mul_en_out <= stage2_valid || (zero_operand && mul_en_in);
            mul_out <= (stage2_valid || (zero_operand && mul_en_in)) ? 
                      (zero_operand ? 16'b0 : final_result) : 16'b0;
        end
    end

endmodule