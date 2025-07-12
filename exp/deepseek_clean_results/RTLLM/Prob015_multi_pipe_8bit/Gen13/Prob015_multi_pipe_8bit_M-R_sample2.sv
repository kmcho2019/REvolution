module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Stage 1: Input registration
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;

    // Stage 2: Partial products
    reg [15:0] stage2_pp0, stage2_pp1, stage2_pp2, stage2_pp3;
    reg stage2_en;

    // Stage 3: Intermediate sums
    reg [15:0] stage3_sum0, stage3_sum1;
    reg stage3_en;

    // Final output
    reg [15:0] final_result;
    reg final_en;

    // Partial product generation wires
    wire [15:0] pp0 = {8'b0, stage1_a} & {16{stage1_b[0]}};
    wire [15:0] pp1 = {7'b0, stage1_a, 1'b0} & {16{stage1_b[1]}};
    wire [15:0] pp2 = {6'b0, stage1_a, 2'b0} & {16{stage1_b[2]}};
    wire [15:0] pp3 = {5'b0, stage1_a, 3'b0} & {16{stage1_b[3]}};
    wire [15:0] pp4 = {4'b0, stage1_a, 4'b0} & {16{stage1_b[4]}};
    wire [15:0] pp5 = {3'b0, stage1_a, 5'b0} & {16{stage1_b[5]}};
    wire [15:0] pp6 = {2'b0, stage1_a, 6'b0} & {16{stage1_b[6]}};
    wire [15:0] pp7 = {1'b0, stage1_a, 7'b0} & {16{stage1_b[7]}};

    // First level adders
    wire [15:0] sum01 = pp0 + pp1;
    wire [15:0] sum23 = pp2 + pp3;
    wire [15:0] sum45 = pp4 + pp5;
    wire [15:0] sum67 = pp6 + pp7;

    // Second level adders
    wire [15:0] sum_low = stage2_pp0 + stage2_pp1;
    wire [15:0] sum_high = stage2_pp2 + stage2_pp3;

    // Pipeline registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
            stage2_pp0 <= 16'b0;
            stage2_pp1 <= 16'b0;
            stage2_pp2 <= 16'b0;
            stage2_pp3 <= 16'b0;
            stage2_en <= 1'b0;
            stage3_sum0 <= 16'b0;
            stage3_sum1 <= 16'b0;
            stage3_en <= 1'b0;
            final_result <= 16'b0;
            final_en <= 1'b0;
        end else begin
            // Stage 1: Input registration
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;

            // Stage 2: First level sums
            stage2_pp0 <= sum01;
            stage2_pp1 <= sum23;
            stage2_pp2 <= sum45;
            stage2_pp3 <= sum67;
            stage2_en <= stage1_en;

            // Stage 3: Second level sums
            stage3_sum0 <= sum_low;
            stage3_sum1 <= sum_high;
            stage3_en <= stage2_en;

            // Final output
            final_result <= stage3_sum0 + stage3_sum1;
            final_en <= stage3_en;
        end
    end

    // Continuous output assignments
    assign mul_en_out = final_en;
    assign mul_out = final_en ? final_result : 16'b0;

endmodule