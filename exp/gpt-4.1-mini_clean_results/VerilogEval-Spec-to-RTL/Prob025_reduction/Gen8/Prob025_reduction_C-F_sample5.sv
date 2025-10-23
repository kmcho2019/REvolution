module TopModule (
    input  [7:0] in,
    output       parity
);
    // Compute even parity as XOR of all input bits using reduction XOR (^).
    // This operator synthesizes to a balanced XOR tree with minimal logic depth,
    // providing optimal performance, low power, and minimal area.
    // Purely combinational logic ensures zero sequential timing constraints.
    assign parity = ^in;
endmodule