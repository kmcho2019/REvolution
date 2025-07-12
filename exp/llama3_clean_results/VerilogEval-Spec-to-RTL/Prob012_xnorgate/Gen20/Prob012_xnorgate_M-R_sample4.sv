// Refactored Module TopModule implements an XNOR gate using continuous assignment
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out // Output signal out
);

// Use continuous assignment for combinational logic
assign out = ~(a ^ b);

endmodule