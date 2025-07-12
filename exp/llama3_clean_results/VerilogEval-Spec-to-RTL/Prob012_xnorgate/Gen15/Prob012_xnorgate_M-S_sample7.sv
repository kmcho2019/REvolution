// Simplified Module TopModule implements an XNOR gate
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out // Output signal out
);

// Directly assign the XNOR operation to the output
assign out = ~(a ^ b);

endmodule