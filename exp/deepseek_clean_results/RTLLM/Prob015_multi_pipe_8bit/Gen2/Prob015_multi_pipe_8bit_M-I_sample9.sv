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
reg [1:0] en_pipeline;  // Reduced to 2 bits
reg [15:0] sum_stage1_reg, sum_stage2_reg;
wire [15:0] partial_products [7:0];
wire [15:0] sum_stage1, sum_stage2;
wire [15:0] final_sum;

// Clock gating for partial products
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pp_gen
        assign partial_products[i] = mul_b_reg[i] ? ({8'b0, mul_a_reg} << i) : 16'b0;
    end
endgenerate

// Balanced adder tree with registered intermediate results
assign sum_stage1 = partial_products[0] + partial_products[1] + 
                   partial_products[2] + partial_products[3];
assign sum_stage2 = partial_products[4] + partial_products[5] + 
                   partial_products[6] + partial_products[7];

// Final sum computation
assign final_sum = sum_stage1_reg + sum_stage2_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        en_pipeline <= 2'b0;
        sum_stage1_reg <= 16'b0;
        sum_stage2_reg <= 16'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        // Pipeline stage 1: Register inputs
        en_pipeline <= {en_pipeline[0], mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Pipeline stage 2: Register intermediate sums
        sum_stage1_reg <= sum_stage1;
        sum_stage2_reg <= sum_stage2;

        // Pipeline stage 3: Register final sum and output
        if (en_pipeline[1]) begin  // Only update when valid
            mul_out <= final_sum;
        end
        mul_en_out <= en_pipeline[1];
    end
end

endmodule