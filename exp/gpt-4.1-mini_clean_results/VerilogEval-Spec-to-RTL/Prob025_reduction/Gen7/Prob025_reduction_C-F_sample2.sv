module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity by XOR'ing all bits of the input vector.
    // The reduction XOR operator (^) synthesizes to a balanced XOR tree,
    // providing minimal logic depth, area, and power consumption.
    // This is purely combinational logic with no sequential elements,
    // ensuring zero sequential timing constraints.
    // This minimal design is optimal for PPA and clarity.
    assign parity = ^in;
endmodule