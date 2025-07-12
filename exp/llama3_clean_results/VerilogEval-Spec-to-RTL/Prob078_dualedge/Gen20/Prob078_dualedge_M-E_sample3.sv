module TopModule(
    input clk,  // Clock signal
    input d,    // Data input
    output reg q // Output of the dual-edge triggered flip-flop
);

reg clk_shifted; // Phase-shifted clock signal
reg q_int;       // Internal flip-flop output

// Generate the phase-shifted clock signal
always @(posedge clk) clk_shifted <= ~clk_shifted;

// Use the phase-shifted clock to capture data on both edges
always @(posedge clk_shifted) q_int <= d;

// Output the captured data
assign q = q_int;

endmodule