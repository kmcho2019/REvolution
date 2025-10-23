module TopModule (
    input clk,
    input d,
    output reg q
);

    // Internal signals
    wire clk_delayed;
    wire edge_pulse;
    reg latch_out;

    // Create a delayed version of the clock
    // Note: In real implementation, use proper delay element or PLL
    assign #1 clk_delayed = clk;

    // Edge detection using XOR
    assign edge_pulse = clk ^ clk_delayed;

    // Transparent latch captures data during edge pulses
    always @(*) begin
        if (edge_pulse) begin
            latch_out = d;
        end
    end

    // Synchronize the output with main clock
    always @(posedge clk) begin
        q <= latch_out;
    end

endmodule