module TopModule (
    input clk,
    input d,
    output reg q
);

    // Create a delayed version of the clock (90° phase shift)
    wire clk_delayed;
    assign #1 clk_delayed = clk;  // Simulation delay - would be a proper buffer chain in real implementation

    // Edge detection: XOR of original and delayed clock creates pulses at edges
    wire edge_pulse;
    assign edge_pulse = clk ^ clk_delayed;

    // Single flip-flop triggered by both edges (through the pulse)
    always @(posedge edge_pulse) begin
        q <= d;
    end

endmodule