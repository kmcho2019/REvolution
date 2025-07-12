module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline registers
reg [7:0] mul_a_reg, mul_b_reg;
reg [1:0] en_pipeline;  // Efficient 2-bit enable pipeline
reg [15:0] pp_low_reg, pp_high_reg;  // Partial product sums
reg [15:0] sum_stage1_reg, sum_stage2_reg;  // Intermediate sums
reg [15:0] final_sum_reg;  // Final result

// Partial products with operand isolation
wire [15:0] partial_products [7:0];
generate
    for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
        assign partial_products[i] = (mul_b_reg[i] && en_pipeline[0]) ? 
                                   {8'b0, mul_a_reg} << i : 16'b0;
    end
endgenerate

// Clock gating for power savings
wire clk_gated = clk & (mul_en_in || en_pipeline[0] || en_pipeline[1]);

// Balanced adder tree with 4 pipeline stages
wire [15:0] sum_low = partial_products[0] + partial_products[1] + 
                     partial_products[2] + partial_products[3];
wire [15:0] sum_high = partial_products[4] + partial_products[5] + 
                      partial_products[6] + partial_products[7];
wire [15:0] final_sum = sum_stage1_reg + sum_stage2_reg;

always @(posedge clk_gated or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        en_pipeline <= 2'b0;
        pp_low_reg <= 16'b0;
        pp_high_reg <= 16'b0;
        sum_stage1_reg <= 16'b0;
        sum_stage2_reg <= 16'b0;
        final_sum_reg <= 16'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        // Pipeline stage 1: Input registration
        en_pipeline <= {en_pipeline[0], mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Pipeline stage 2: Partial product sums
        pp_low_reg <= sum_low;
        pp_high_reg <= sum_high;

        // Pipeline stage 3: Intermediate sums
        sum_stage1_reg <= pp_low_reg;
        sum_stage2_reg <= pp_high_reg;

        // Pipeline stage 4: Final result
        final_sum_reg <= final_sum;
        
        // Output control with enable gating
        mul_en_out <= en_pipeline[1];
        if (en_pipeline[1]) begin
            mul_out <= final_sum_reg;
        end else begin
            mul_out <= 16'b0;
        end
    end
end

endmodule