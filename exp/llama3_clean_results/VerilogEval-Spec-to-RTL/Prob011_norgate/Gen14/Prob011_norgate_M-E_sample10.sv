// Module TopModule implements a NOR gate using a combination of an OR gate and an inverter.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Intermediate signal to hold the result of the OR operation
logic or_result;

// Implement the OR operation
assign or_result = a | b;

// Use an inverter to obtain the NOR result
assign out = ~or_result;

// This implementation demonstrates a modular approach to designing a NOR gate,
// breaking it down into smaller, more manageable components.

endmodule