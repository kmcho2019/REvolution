// Module TopModule implements a NOR gate directly.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Directly implement the NOR operation using a single logical expression.
assign out = ~(a | b);  // NOR operation directly assigned to output

// This simplified implementation provides a clear and efficient solution for the NOR gate.

endmodule