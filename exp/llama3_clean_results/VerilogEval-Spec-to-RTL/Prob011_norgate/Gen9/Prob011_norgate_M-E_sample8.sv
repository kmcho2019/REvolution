// Novel architectural implementation of a NOR gate using basic logic gates.
module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);

// Intermediate signal for the OR operation
logic or_result;

// Implement the OR operation
assign or_result = a | b;

// The NOR operation is the inverse of the OR operation
assign out = ~or_result;

endmodule