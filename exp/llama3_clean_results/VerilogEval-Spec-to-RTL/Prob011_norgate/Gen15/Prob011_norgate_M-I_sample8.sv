// Improved Module TopModule implementing a NOR gate with optimized PPA.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Direct implementation of NOR gate.
assign out = ~(a | b);  // NOR operation directly implemented

endmodule