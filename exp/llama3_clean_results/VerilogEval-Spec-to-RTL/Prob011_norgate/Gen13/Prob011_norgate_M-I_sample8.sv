// Module TopModule implements a NOR gate using continuous assignment for efficiency.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Implement the NOR operation using a continuous assignment for simplicity and efficiency.
assign out = ~(a | b);  // NOR operation directly implemented using continuous assignment

// This implementation is optimized for PPA metrics by using continuous assignment,
// which is generally more efficient than always blocks for combinatorial logic.

endmodule