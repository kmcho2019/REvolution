module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // Stage 1: Check first bit (1)
    reg stage1_match;
    // Stage 2: Check second bit (1) if first matched
    reg stage2_match;
    // Stage 3: Check third bit (0) if first two matched
    reg stage3_match;
    // Stage 4: Check fourth bit (1) if first three matched
    reg stage4_match;

    always @(posedge clk) begin
        if (reset) begin
            stage1_match <= 1'b0;
            stage2_match <= 1'b0;
            stage3_match <= 1'b0;
            stage4_match <= 1'b0;
            start_shifting <= 1'b0;
        end else if (!start_shifting) begin
            // Stage 1: Check first bit (1)
            stage1_match <= (data == 1'b1);

            // Stage 2: Check second bit (1) if first matched
            stage2_match <= stage1_match && (data == 1'b1);

            // Stage 3: Check third bit (0) if first two matched
            stage3_match <= stage2_match && (data == 1'b0);

            // Stage 4: Check fourth bit (1) if first three matched
            stage4_match <= stage3_match && (data == 1'b1);

            // Final detection
            start_shifting <= stage4_match;
        end
    end

endmodule