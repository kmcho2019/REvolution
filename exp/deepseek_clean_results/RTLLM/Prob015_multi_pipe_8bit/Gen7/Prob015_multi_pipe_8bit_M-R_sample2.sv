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
reg [7:0] stage1_a, stage1_b;
reg stage1_en;
reg [15:0] stage2_sum1, stage2_sum2;
reg stage2_en;
reg [15:0] stage3_result;
reg stage3_en;

// Partial product generation (combinational)
wire [15:0] pp [7:0];
assign pp[0] = {8'b0, stage1_a} & {16{stage1_b[0]}};
assign pp[1] = ({8'b0, stage1_a} << 1) & {16{stage1_b[1]}};
assign pp[2] = ({8'b0, stage1_a} << 2) & {16{stage1_b[2]}};
assign pp[3] = ({8'b0, stage1_a} << 3) & {16{stage1_b[3]}};
assign pp[4] = ({8'b0, stage1_a} << 4) & {16{stage1_b[4]}};
assign pp[5] = ({8'b0, stage1_a} << 5) & {16{stage1_b[5]}};
assign pp[6] = ({8'b0, stage1_a} << 6) & {16{stage1_b[6]}};
assign pp[7] = ({8'b0, stage1_a} << 7) & {16{stage1_b[7]}};

// Adder tree (combinational)
wire [15:0] sum1 = pp[0] + pp[1] + pp[2] + pp[3];
wire [15:0] sum2 = pp[4] + pp[5] + pp[6] + pp[7];
wire [15:0] final_sum = sum1 + sum2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        stage1_a <= 8'b0;
        stage1_b <= 8'b0;
        stage1_en <= 1'b0;
        stage2_sum1 <= 16'b0;
        stage2_sum2 <= 16'b0;
        stage2_en <= 1'b0;
        stage3_result <= 16'b0;
        stage3_en <= 1'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        // Stage 1: Input sampling
        stage1_en <= mul_en_in;
        if (mul_en_in) begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
        end

        // Stage 2: Partial sum calculation
        stage2_sum1 <= sum1;
        stage2_sum2 <= sum2;
        stage2_en <= stage1_en;

        // Stage 3: Final sum
        stage3_result <= final_sum;
        stage3_en <= stage2_en;

        // Output stage
        mul_out <= stage3_en ? stage3_result : 16'b0;
        mul_en_out <= stage3_en;
    end
end

endmodule