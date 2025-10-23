module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity as the XOR of all 8 input bits.
    //
    // The Verilog reduction XOR operator (^) synthesizes to a balanced XOR tree,
    // ensuring minimal logic depth, area, and power consumption.
    //
    // This design is purely combinational with no registers or state,
    // so timing constraints and setup/hold concerns do not apply here.
    //
    // Avoiding intermediate wires reduces switching activity and simplifies routing.
    //
    // Further PPA improvements would come from system-level power management
    // or gating input signals, beyond the scope of this parity module.
    assign parity = ^in;
endmodule