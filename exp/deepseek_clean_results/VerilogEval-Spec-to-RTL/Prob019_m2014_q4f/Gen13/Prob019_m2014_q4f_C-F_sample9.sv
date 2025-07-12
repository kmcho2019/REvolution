/*
 * TopModule: Implements in1 AND (NOT in2)
 * Bubble notation indicates in2 inversion
 * Optimal implementation with minimal gates
 */
module TopModule #(
    parameter WIDTH = 1  // Allows potential vectorization
) (
    input  wire in1,
    input  wire in2,
    output wire out
);
    // Core logic: AND with inverted second input
    assign out = in1 & ~in2;
endmodule