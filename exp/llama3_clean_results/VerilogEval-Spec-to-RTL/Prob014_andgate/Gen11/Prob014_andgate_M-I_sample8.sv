module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out // Output of the AND gate
);

// Implement a 2-input AND gate using a continuous assignment
// This approach is efficient for simple logic operations
assign out = a & b;

endmodule