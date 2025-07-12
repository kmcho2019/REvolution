module TopModule (
    input  clk,
    input  d,
    output reg q
);

    // Internal signal: delayed version of clk to generate doubled frequency clock
    reg clk_dly = 0;

    always @(posedge clk) begin
        clk_dly <= clk;
    end

    // Generate clk_x2 by XORing clk and clk_dly; toggles on both edges of clk
    wire clk_x2 = clk ^ clk_dly;

    // Sample input d at doubled frequency clock clk_x2
    reg sampled_d;

    always @(posedge clk_x2) begin
        sampled_d <= d;
    end

    // Synchronize sampled data back to original clock domain using double flop
    reg sync_stage1, sync_stage2;

    always @(posedge clk) begin
        sync_stage1 <= sampled_d;
        sync_stage2 <= sync_stage1;
        q <= sync_stage2;
    end

endmodule