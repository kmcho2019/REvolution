// Module declaration for a simple AND gate
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic q   // Output signal q
);

    // Direct assignment for simplicity and efficiency
    assign q = a && b;

endmodule