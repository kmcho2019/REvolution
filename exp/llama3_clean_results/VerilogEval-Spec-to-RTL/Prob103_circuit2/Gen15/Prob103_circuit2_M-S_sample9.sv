// Simplified TopModule: Implementing the logic observed from simulation waveforms
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Direct implementation using XOR to check for an even number of 1's
    assign q = ~(a ^ b ^ c ^ d);

endmodule