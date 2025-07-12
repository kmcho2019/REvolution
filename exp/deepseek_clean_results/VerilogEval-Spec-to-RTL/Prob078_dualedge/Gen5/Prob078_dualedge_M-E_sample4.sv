module TopModule (
    input clk,
    input d,
    output reg q
);

    // Generate phase-shifted clocks
    reg clk_phase;
    always @(negedge clk) begin
        clk_phase <= ~clk_phase;
    end

    // Create pulse on both edges
    wire sample_pulse = clk ^ clk_phase;

    // Single flip-flop with enable
    always @(posedge clk) begin
        if (sample_pulse) begin
            q <= d;
        end
    end

endmodule