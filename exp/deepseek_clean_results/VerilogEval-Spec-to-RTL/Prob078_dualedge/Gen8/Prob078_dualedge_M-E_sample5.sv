module TopModule (
    input clk,
    input d,
    output reg q
);

    wire clk_pulse;
    reg clk_delayed;

    // Create a delayed version of the clock
    always @(posedge clk or negedge clk) begin
        clk_delayed <= clk;
    end

    // Generate pulses on both edges
    assign clk_pulse = clk ^ clk_delayed;

    // Single flip-flop triggered by pulses
    always @(posedge clk_pulse) begin
        q <= d;
    end

endmodule