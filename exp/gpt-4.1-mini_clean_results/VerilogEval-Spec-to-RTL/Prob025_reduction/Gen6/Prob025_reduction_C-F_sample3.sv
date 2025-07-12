module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity by XOR'ing all bits of the input vector.
    // The reduction XOR operator (^) synthesizes to a balanced XOR tree,
    // yielding minimal logic depth, area, and power consumption.
    //
    // This is a purely combinational circuit with no registers or state,
    // so it imposes no sequential timing constraints.
    //
    // Any further improvements would require system-level techniques
    // such as clock gating or power gating, which are beyond the scope
    // of this simple parity computation module.
    assign parity = ^in;
endmodule