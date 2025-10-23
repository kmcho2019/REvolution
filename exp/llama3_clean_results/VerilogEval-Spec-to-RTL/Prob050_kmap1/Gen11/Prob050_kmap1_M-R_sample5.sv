// Refactored module with explicit type declaration for the output signal.
module TopModule(
    input logic a,  // Explicitly declare input signals as logic type.
    input logic b,
    input logic c,
    output logic out  // Declare the output signal as logic type for clarity.
);

// The logic remains the same, using a continuous assignment for the OR operation.
assign out = a | b | c;

endmodule