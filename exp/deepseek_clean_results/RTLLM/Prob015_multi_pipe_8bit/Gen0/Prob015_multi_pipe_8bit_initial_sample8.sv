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
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [7:0] pp [7:0];  // Partial products
reg [15:0] sum_stage1 [3:0];
reg [15:0] sum_stage2 [1:0];
reg [15:0] sum_stage3;
reg [2:0] en_pipe;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        for (integer i = 0; i < 8; i = i+1) pp[i] <= 8'b0;
        for (integer j = 0; j < 4; j = j+1) sum_stage1[j] <= 16'b0;
        for (integer k = 0; k < 2; k = k+1) sum_stage2[k] <= 16'b0;
        sum_stage3 <= 16'b0;
        en_pipe <= 3'b0;
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end
    else begin
        // Pipeline enable signal
        en_pipe <= {en_pipe[1:0], mul_en_in};
        mul_en_out <= en_pipe[2];

        // Stage 0: Register inputs and generate partial products
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        for (integer i = 0; i < 8; i = i+1) begin
            pp[i] <= mul_b_reg[i] ? mul_a_reg : 8'b0;
        end

        // Stage 1: First level of addition
        if (en_pipe[0]) begin
            sum_stage1[0] <= {8'b0, pp[0]} + ({7'b0, pp[1], 1'b0});
            sum_stage1[1] <= {6'b0, pp[2], 2'b0} + ({5'b0, pp[3], 3'b0});
            sum_stage1[2] <= {4'b0, pp[4], 4'b0} + ({3'b0, pp[5], 5'b0});
            sum_stage1[3] <= {2'b0, pp[6], 6'b0} + ({1'b0, pp[7], 7'b0});
        end

        // Stage 2: Second level of addition
        if (en_pipe[1]) begin
            sum_stage2[0] <= sum_stage1[0] + sum_stage1[1];
            sum_stage2[1] <= sum_stage1[2] + sum_stage1[3];
        end

        // Stage 3: Final addition
        if (en_pipe[2]) begin
            sum_stage3 <= sum_stage2[0] + sum_stage2[1];
            mul_out <= sum_stage3;
        end
        else begin
            mul_out <= 16'b0;
        end
    end
end

endmodule