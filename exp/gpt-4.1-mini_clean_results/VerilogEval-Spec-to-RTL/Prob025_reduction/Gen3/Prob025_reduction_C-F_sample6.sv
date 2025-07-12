module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity by XOR'ing all bits of the input vector.
    // The reduction XOR operator (^) synthesizes to a balanced XOR tree,
    // yielding minimal logic depth, area, and power consumption.
    // This is a purely combinational circuit with no registers or state,
    // imposing no sequential timing constraints.
    // Further improvements would involve system-level power or clock gating,
    // which are beyond the scope of this simple module.
    assign parity = ^in;
endmodule