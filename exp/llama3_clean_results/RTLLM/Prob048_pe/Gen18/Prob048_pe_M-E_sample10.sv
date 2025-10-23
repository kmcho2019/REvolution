module pe (
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] a,  // Input operand A
    input [31:0] b,  // Input operand B
    output [31:0] c  // Accumulated result
);

// Configurable Stage
reg [31:0] stage1, stage2, stage3, stage4;
reg [31:0] mult_result, add_result;

always @(posedge clk) begin
    if (rst) begin
        stage1 <= 32'd0;
        stage2 <= 32'd0;
        stage3 <= 32'd0;
        stage4 <= 32'd0;
    end else begin
        // Stage 1: Input Buffering
        stage1 <= a;
        stage2 <= b;

        // Stage 2: Multiplication
        mult_result <= stage1 * stage2;

        // Stage 3: Addition
        add_result <= mult_result + stage3;

        // Stage 4: Output Buffering
        stage4 <= add_result;
    end
end

// Output Assignment
assign c = stage4;

endmodule