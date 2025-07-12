module TopModule (
    input clk,
    input d,
    output q
);

    reg q_ff, q_latch;
    wire clk_edge;

    // Edge detector (creates pulse on both edges)
    reg clk_dly;
    always @(posedge clk or negedge clk) clk_dly <= clk;
    assign clk_edge = clk ^ clk_dly;

    // Positive edge flip-flop
    always @(posedge clk) begin
        q_ff <= d;
    end

    // Negative edge transparent latch
    always @(*) begin
        if (clk_edge && !clk) begin
            q_latch = d;
        end
    end

    // Output selection
    assign q = clk ? q_ff : q_latch;

endmodule