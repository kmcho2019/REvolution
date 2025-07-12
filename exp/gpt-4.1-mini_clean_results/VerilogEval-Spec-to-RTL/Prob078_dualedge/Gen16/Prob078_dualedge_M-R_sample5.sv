module TopModule (
    input clk,
    input d,
    output q
);
    reg q_pos_ff;      // Flip-flop capturing data on posedge clk
    reg q_neg_ff;      // Flip-flop capturing data on negedge clk emulated
    reg clk_dly;       // Delayed version of clk to detect negedge

    always @(posedge clk) begin
        q_pos_ff <= d;     // Positive edge flip-flop

        clk_dly <= clk;    // Delay clock for negedge detection
        if (clk_dly && ~clk) begin
            // Emulate negative edge FF behavior on posedge by detecting falling edge of clk
            q_neg_ff <= d;
        end
    end

    // Multiplex output based on clock level
    assign q = clk ? q_pos_ff : q_neg_ff;

endmodule