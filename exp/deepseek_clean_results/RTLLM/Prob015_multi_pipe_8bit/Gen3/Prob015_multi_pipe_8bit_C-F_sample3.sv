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
reg [7:0] a_reg, b_reg;
reg [1:0] en_pipeline;  // Reduced to 2 bits for control
reg [2:0] pipe_stage;   // Track pipeline depth separately

// Partial products with clock gating
wire [15:0] pp [0:7];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pp_gen
        assign pp[i] = b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
    end
endgenerate

// Progressive adder stages
wire [11:0] sum_stage1a = pp[0][7:0] + pp[1][7:0];  // 8-bit + 8-bit = 9-bit
wire [11:0] sum_stage1b = pp[2][7:0] + pp[3][7:0];  // But keep 12-bit for alignment
wire [15:0] sum_stage2a = {4'b0, sum_stage1a} + {4'b0, sum_stage1b};

wire [15:0] sum_stage2b = pp[4] + pp[5] + pp[6] + pp[7];  // Full 16-bit adds

// Pipeline registers
reg [15:0] stage1_reg, stage2_reg;
reg [15:0] final_sum_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_reg <= 8'b0;
        b_reg <= 8'b0;
        en_pipeline <= 2'b0;
        pipe_stage <= 3'b0;
        stage1_reg <= 16'b0;
        stage2_reg <= 16'b0;
        final_sum_reg <= 16'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        // Pipeline stage 0: Input registers
        en_pipeline <= {en_pipeline[0], mul_en_in};
        pipe_stage <= {pipe_stage[1:0], mul_en_in};
        
        if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end

        // Pipeline stage 1: First level additions
        stage1_reg <= sum_stage2a;

        // Pipeline stage 2: Second level additions
        stage2_reg <= sum_stage2b;

        // Pipeline stage 3: Final addition
        final_sum_reg <= stage1_reg + stage2_reg;

        // Output stage
        mul_en_out <= pipe_stage[2];  // Valid after 3 cycles
        if (pipe_stage[2]) begin      // Only update when valid
            mul_out <= final_sum_reg;
        end
    end
end

endmodule