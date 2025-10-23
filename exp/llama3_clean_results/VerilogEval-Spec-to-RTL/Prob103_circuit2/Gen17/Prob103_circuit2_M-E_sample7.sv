// TopModule: An optimized combinational circuit implementing the simplified logic
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Implementing the simplified logic using a Karnaugh map
    // The expression is derived from the Karnaugh map simplification
    assign q = ~(a & b) & ~(c & d) | ~(a & c) & ~(b & d) | ~(a & d) & ~(b & c);

endmodule