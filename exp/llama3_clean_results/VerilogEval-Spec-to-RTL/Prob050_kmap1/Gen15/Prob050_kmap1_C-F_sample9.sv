module TopModule(
    input logic a,  // Explicitly declare input signals as logic type.
    input logic b,
    input logic c,
    output logic out  // Declare the output signal as logic type for clarity.
);

// Directly implement the simplified logic expression.
assign out = a | b | c;

endmodule