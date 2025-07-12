module TopModule(
    input  a,  // Unused input, included for interface completeness
    input  b,  // Input contributing directly to output q
    input  c,  // Input contributing directly to output q
    input  d,  // Unused input, included for interface completeness
    output q   // Output is high if either b or c is high
);

    // Combinational logic: output q is logical OR of inputs b and c.
    // This matches the waveform behavior exactly:
    // q = 1 if (b == 1) or (c == 1), else q = 0.
    assign q = b | c;

endmodule