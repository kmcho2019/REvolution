module TopModule (
    input clk,
    input d,
    output reg q
);
    // This module emulates dual-edge triggered flip-flop by creating a toggle signal
    // that toggles at every half clk period, using only posedge triggered logic,
    // then using this toggle as a clock enable to sample 'd' twice per clk cycle.

    reg toggle;          // toggles every half clk cycle, implemented by detecting clk edges
    reg clk_dly;         // delayed version of clk to detect edges

    wire clk_edge_pulse; // pulse asserted at every edge of clk (both posedge and negedge)

    // Capture delayed clk for edge detection
    always @(posedge clk) begin
        clk_dly <= clk;
    end

    // Generate a pulse at every edge by XOR of current and delayed clk
    assign clk_edge_pulse = clk ^ clk_dly;

    // Toggle flip-flop toggles at every clk edge pulse (detected on posedge clk)
    // Use clk_edge_pulse synchronously sampled on posedge clk to toggle 'toggle'
    // This creates a signal toggling at double frequency of clk edges.
    always @(posedge clk) begin
        if (clk_edge_pulse)
            toggle <= ~toggle;
    end

    // On each posedge clk, if toggle changed, sample d into q
    // But since toggle changes on each edge (pos or neg), combine toggle and clk to generate enable

    // Generate clock enable signal: toggle is updated on posedge clk, but toggling on edges
    // Use toggle to enable sampling every half clock cycle:
    wire clk_enable = clk_edge_pulse;

    // Single flip-flop capturing d on posedge clk when enable is high (i.e. at both edges)
    always @(posedge clk) begin
        if (clk_enable)
            q <= d;
    end

endmodule