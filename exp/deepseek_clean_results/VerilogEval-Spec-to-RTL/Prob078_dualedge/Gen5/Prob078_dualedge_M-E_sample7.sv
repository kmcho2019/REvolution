module TopModule (
    input clk,
    input d,
    output reg q
);

    wire clk_pulse;
    reg clk_dly;

    // Create delayed version of clock
    always @(clk) begin
        clk_dly <= clk;
    end

    // Generate pulse on both edges
    assign clk_pulse = clk ^ clk_dly;

    // Single flip-flop triggered on both edges
    always @(posedge clk_pulse) begin
        q <= d;
    end

endmodule