module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity by XOR'ing all bits of the input vector.
    //
    // The Verilog reduction XOR operator (^) synthesizes to a balanced XOR tree,
    // resulting in minimal logic depth, low area, and low power consumption.
    //
    // This module is purely combinational with no registers or state elements,
    // so it introduces no sequential timing constraints.
    //
    // Any further PPA (Power, Performance, Area) improvements would involve system-level
    // techniques like input signal gating or power gating, which are beyond this module's scope.
    assign parity = ^in;
endmodule