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
reg [7:0] stage0_a, stage0_b;
reg [7:0] stage1_pp [7:0];  // Partial products
reg [15:0] stage2_sum [3:0];  // First adder level
reg [15:0] stage3_sum [1:0];  // Second adder level
reg [15:0] stage4_result;     // Final result

// Pipeline enable signals
reg [3:0] pipeline_en;

// Combinational partial products
wire [7:0] pp [7:0];
generate
    genvar i;
    for (i = 0; i < 8; i = i+1) begin : pp_gen
        assign pp[i] = stage0_b[i] ? stage0_a : 8'b0;
    end
endgenerate

// Combinational adders
wire [15:0] sum_stage1 [3:0];
assign sum_stage1[0] = {8'b0, pp[0]} + {7'b0, pp[1], 1'b0};
assign sum_stage1[1] = {6'b0, pp[2], 2'b0} + {5'b0, pp[3], 3'b0};
assign sum_stage1[2] = {4'b0, pp[4], 4'b0} + {3'b0, pp[5], 5'b0};
assign sum_stage1[3] = {2'b0, pp[6], 6'b0} + {1'b0, pp[7], 7'b0};

wire [15:0] sum_stage2 [1:0];
assign sum_stage2[0] = stage2_sum[0] + stage2_sum[1];
assign sum_stage2[1] = stage2_sum[2] + stage2_sum[3];

wire [15:0] sum_stage3;
assign sum_stage3 = stage3_sum[0] + stage3_sum[1];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        stage0_a <= 8'b0;
        stage0_b <= 8'b0;
        for (integer i = 0; i < 8; i = i+1) stage1_pp[i] <= 8'b0;
        for (integer j = 0; j < 4; j = j+1) stage2_sum[j] <= 16'b0;
        for (integer k = 0; k < 2; k = k+1) stage3_sum[k] <= 16'b0;
        stage4_result <= 16'b0;
        pipeline_en <= 4'b0;
        mul_en_out <= 1'b0;
        mul_out <= 16'b0;
    end
    else begin
        // Propagate enable signal through pipeline
        pipeline_en <= {pipeline_en[2:0], mul_en_in};
        mul_en_out <= pipeline_en[3];

        // Stage 0: Input registration
        if (mul_en_in) begin
            stage0_a <= mul_a;
            stage0_b <= mul_b;
        end

        // Stage 1: Partial product registration
        if (pipeline_en[0]) begin
            for (integer i = 0; i < 8; i = i+1) begin
                stage1_pp[i] <= pp[i];
            end
        end

        // Stage 2: First adder level
        if (pipeline_en[1]) begin
            for (integer i = 0; i < 4; i = i+1) begin
                stage2_sum[i] <= sum_stage1[i];
            end
        end

        // Stage 3: Second adder level
        if (pipeline_en[2]) begin
            for (integer i = 0; i < 2; i = i+1) begin
                stage3_sum[i] <= sum_stage2[i];
            end
        end

        // Stage 4: Final result
        if (pipeline_en[3]) begin
            stage4_result <= sum_stage3;
            mul_out <= stage4_result;
        end
        else begin
            mul_out <= 16'b0;
        end
    end
end

endmodule