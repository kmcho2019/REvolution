// Module TopModule: Implements a simple AND gate.
// Inputs: a and b
// Output: q (the logical AND of a and b)
module TopModule(
    input  logic a,  // Input a
    input  logic b,  // Input b
    output logic q   // Output: a AND b
);
    // Continuous assignment to output q
    assign q = a & b; // q is the logical AND of inputs a and b
endmodule