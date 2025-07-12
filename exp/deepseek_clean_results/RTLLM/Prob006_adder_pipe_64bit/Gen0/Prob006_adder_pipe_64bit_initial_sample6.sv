module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

    // Pipeline registers
    reg [15:0] a_stage1, a_stage2, a_stage3, a_stage4;
    reg [15:0] b_stage1, b_stage2, b_stage3, b_stage4;
    reg carry_stage1, carry_stage2, carry_stage3, carry_stage4;
    reg [15:0] sum_stage1, sum_stage2, sum_stage3, sum_stage4;
    reg en_stage1, en_stage2, en_stage3, en_stage4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            a_stage1 <= 16'b0; b_stage1 <= 16'b0; carry_stage1 <= 1'b0; sum_stage1 <= 16'b0; en_stage1 <= 1'b0;
            a_stage2 <= 16'b0; b_stage2 <= 16'b0; carry_stage2 <= 1'b0; sum_stage2 <= 16'b0; en_stage2 <= 1'b0;
            a_stage3 <= 16'b0; b_stage3 <= 16'b0; carry_stage3 <= 1'b0; sum_stage3 <= 16'b0; en_stage3 <= 1'b0;
            a_stage4 <= 16'b0; b_stage4 <= 16'b0; carry_stage4 <= 1'b0; sum_stage4 <= 16'b0; en_stage4 <= 1'b0;
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 1: Process bits [15:0]
            a_stage1 <= adda[15:0];
            b_stage1 <= addb[15:0];
            carry_stage1 <= 1'b0;  // No carry in for first stage
            {carry_stage2, sum_stage1} <= adda[15:0] + addb[15:0] + 1'b0;
            en_stage1 <= i_en;

            // Stage 2: Process bits [31:16]
            a_stage2 <= adda[31:16];
            b_stage2 <= addb[31:16];
            {carry_stage3, sum_stage2} <= adda[31:16] + addb[31:16] + carry_stage2;
            en_stage2 <= en_stage1;

            // Stage 3: Process bits [47:32]
            a_stage3 <= adda[47:32];
            b_stage3 <= addb[47:32];
            {carry_stage4, sum_stage3} <= adda[47:32] + addb[47:32] + carry_stage3;
            en_stage3 <= en_stage2;

            // Stage 4: Process bits [63:48]
            a_stage4 <= adda[63:48];
            b_stage4 <= addb[63:48];
            {result[64], sum_stage4} <= adda[63:48] + addb[63:48] + carry_stage4;
            en_stage4 <= en_stage3;

            // Combine results from all stages
            result[63:0] <= {sum_stage4, sum_stage3, sum_stage2, sum_stage1};
            o_en <= en_stage4;
        end
    end

endmodule