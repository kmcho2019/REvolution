module sub_64bit (
    input clk,
    input en,        // Enable signal for clock gating
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    // Pipeline registers
    reg [63:0] stage1_A, stage1_B;
    reg [63:0] stage2_result;
    reg stage2_ovf;

    // Clock gating logic
    wire gated_clk;
    assign gated_clk = clk & en;

    // Carry-select adder implementation (4x16-bit)
    always @(posedge gated_clk) begin
        // Stage 1: Input registration
        stage1_A <= A;
        stage1_B <= B;

        // Stage 2: Carry-select subtraction (4x16-bit chunks)
        {stage2_result[15:0], stage2_ovf} <= {1'b0, stage1_A[15:0]} - {1'b0, stage1_B[15:0]};
        {stage2_result[31:16], } <= {1'b0, stage1_A[31:16]} - {1'b0, stage1_B[31:16]} - stage2_ovf;
        {stage2_result[47:32], } <= {1'b0, stage1_A[47:32]} - {1'b0, stage1_B[47:32]} - stage2_ovf;
        {stage2_result[63:48], } <= {1'b0, stage1_A[63:48]} - {1'b0, stage1_B[63:48]} - stage2_ovf;

        // Stage 3: Output registration and overflow detection
        result <= stage2_result;
        overflow <= (stage1_A[63] != stage1_B[63]) && (stage1_A[63] != stage2_result[63]);
    end

endmodule