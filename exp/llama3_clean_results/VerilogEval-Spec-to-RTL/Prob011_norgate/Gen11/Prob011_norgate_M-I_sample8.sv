// Module TopModule: Implements a NOR gate.
// The NOR gate outputs 1 only if both inputs are 0.
module TopModule(
    input  logic a, // Input signal a
    input  logic b, // Input signal b
    output logic out // Output of the NOR operation
);
// Perform NOR operation using bitwise OR and NOT operators.
assign out = ~(a | b); // out is 1 only if (a OR b) is 0.

endmodule