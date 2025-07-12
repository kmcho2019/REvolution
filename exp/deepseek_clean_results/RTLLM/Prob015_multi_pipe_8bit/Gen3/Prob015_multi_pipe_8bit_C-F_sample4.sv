module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline control
reg [1:0] en_pipeline;  // Reduced to 2 bits for 3 pipeline stages
reg [7:0] a_reg, b_reg;

// Partial products with clock gating
wire [15:0] pp [0:7];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pp_gen
        assign pp[i] = (en_pipeline[0] & b_reg[i]) ? ({8'b0, a_reg} << i) : 16'b0;
    end
endgenerate

// Pipeline registers
reg [15:0] sum_stage1 [0:1];  // First level additions (2 pairs)
reg [15:0] sum_stage2;        // Second level addition
reg [15:0] sum_stage3;        // Final sum register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        a_reg <= 8'b0;
        b_reg <= 8'b0;
        en_pipeline <= 2'b0;
        sum_stage1[0] <= 16'b0;
        sum_stage1[1] <= 16'b0;
        sum_stage2 <= 16'b0;
        sum_stage3 <= 16'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        // Pipeline stage 0: Input registers
        en_pipeline[0] <= mul_en_in;
        if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end

        // Pipeline stage 1: First level additions (balanced pairs)
        en_pipeline[1] <= en_pipeline[0];
        sum_stage1[0] <= pp[0] + pp[1] + pp[2] + pp[3];  // Group of 4
        sum_stage1[1] <= pp[4] + pp[5] + pp[6] + pp[7];  // Group of 4

        // Pipeline stage 2: Second level addition
        sum_stage2 <= sum_stage1[0] + sum_stage1[1];

        // Pipeline stage 3: Final sum register
        if (en_pipeline[1]) begin  // Only update when valid
            sum_stage3 <= sum_stage2;
        end

        // Output assignment
        mul_en_out <= en_pipeline[1];
        mul_out <= sum_stage3;
    end
end

endmodule