module TopModule(
    input logic a,  // Explicitly declare input signals as logic type for clarity.
    input logic b,
    input logic c,
    output logic out  // Declare the output signal as logic type for clarity and maintainability.
);

// Directly implement the simplified logic expression that represents the Karnaugh map.
assign out = a | b | c;

endmodule