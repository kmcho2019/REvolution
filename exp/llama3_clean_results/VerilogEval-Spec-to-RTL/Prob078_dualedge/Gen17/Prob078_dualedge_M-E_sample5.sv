module TopModule(
    input clk,  // Clock signal
    input d,    // Data input
    output reg q // Output of the dual-edge triggered flip-flop
);

// Generate a phase-shifted clock signal
reg clk_phase_shifted;
always @(posedge clk or negedge clk) begin
    clk_phase_shifted <= ~clk; // Simple phase-shifting using inversion
end

// Use the original clock and the phase-shifted clock to create a dual-edge triggered flip-flop
always @(posedge clk or posedge clk_phase_shifted) begin
    q <= d; // Capture data on both edges of the original clock
end

endmodule