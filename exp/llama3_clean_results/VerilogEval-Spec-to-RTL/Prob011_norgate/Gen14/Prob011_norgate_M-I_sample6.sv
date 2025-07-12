// Optimized Module TopModule implementing a NOR gate.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Direct implementation of NOR gate.
assign out = ~(a | b);  // NOR operation directly implemented

endmodule