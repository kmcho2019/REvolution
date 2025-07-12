module TopModule (
    input clk,
    input d,
    output reg q
);

    reg clk_delayed;
    wire sample_pulse;

    // Create a delayed version of the clock
    always @(posedge clk) begin
        clk_delayed <= ~clk_delayed;
    end

    // Edge detection using XOR
    assign sample_pulse = clk ^ clk_delayed;

    // Single flip-flop capturing on both edges
    always @(posedge sample_pulse) begin
        q <= d;
    end

endmodule