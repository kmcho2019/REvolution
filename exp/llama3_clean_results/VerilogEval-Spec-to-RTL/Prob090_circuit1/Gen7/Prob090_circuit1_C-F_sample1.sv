// TopModule: A combinational circuit implementing a basic AND gate operation.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic q   // Output result of a AND b
);
assign q = a & b;  // Continuous assignment for the AND operation
endmodule