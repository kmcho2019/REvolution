// Superior solution combining the strengths of both examples.
module TopModule(
    input logic a,  // Explicitly declare input signals as logic type for clarity.
    input logic b,
    input logic c,
    output logic out  // Declare the output signal as logic type for clarity and maintainability.
);

// Directly implement the simplified OR logic for simplicity and efficiency.
assign out = a | b | c;

endmodule