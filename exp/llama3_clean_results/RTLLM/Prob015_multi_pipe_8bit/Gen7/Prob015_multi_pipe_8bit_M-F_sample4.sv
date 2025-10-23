module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Internal registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg [7:0] partial_sum_reg; // Intermediate sum register
reg [2:0] count; // Counter for multiplier bits
reg mul_en_out_reg; // Output enable register

// Pipeline stages
reg [15:0] stage1_reg;
reg [15:0] stage2_reg;
reg [15:0] stage3_reg;

// Always block for sequential logic
always @(posedge clk) begin
    if (~rst_n) begin
        // Reset all registers on low reset
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
        partial_sum_reg <= 8'b0;
        count <= 3'b000;
        mul_en_out_reg <= 1'b0;
        stage1_reg <= 16'b0;
        stage2_reg <= 16'b0;
        stage3_reg <= 16'b0;
    end else begin
        // Input control and register update
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_out_reg <= 16'b0; // Reset mul_out_reg
            partial_sum_reg <= 8'b0; // Reset partial_sum_reg
            count <= 3'b000; // Reset count
            mul_en_out_reg <= 1'b1;
            stage1_reg <= 16'b0;
            stage2_reg <= 16'b0;
            stage3_reg <= 16'b0;
        end else begin
            // Partial product generation and accumulation
            if (count < 3'b111 && mul_en_out_reg) begin
                if (mul_b_reg[count]) begin
                    partial_sum_reg <= partial_sum_reg + (mul_a_reg << count);
                end
                count <= count + 1'b1;
            end

            // Pipeline stages
            if (mul_en_out_reg) begin
                stage1_reg <= partial_sum_reg;
                stage2_reg <= stage1_reg;
                stage3_reg <= stage2_reg;
                if (count == 3'b111) begin
                    mul_out_reg <= stage3_reg;
                    mul_en_out_reg <= 1'b0;
                end
            end
        end
    end
end

// Output assignments
assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_out_reg;

endmodule