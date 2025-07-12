// Module TopModule implements a NOR gate directly in the output port declaration for simplicity.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Directly implement the NOR operation in the output port declaration for simplicity and efficiency.
assign out = ~(a | b);  // NOR operation directly implemented

// This simplified implementation reduces complexity while maintaining the functionality of the NOR gate.

endmodule