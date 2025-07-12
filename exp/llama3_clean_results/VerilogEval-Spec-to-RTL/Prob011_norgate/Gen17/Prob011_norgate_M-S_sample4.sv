// TopModule implements a simplified NOR gate using a single logical expression.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Assign the output using a simplified NOR gate expression.
assign out = ~(a | b);

// This implementation directly expresses the NOR logic without conditional statements.
endmodule