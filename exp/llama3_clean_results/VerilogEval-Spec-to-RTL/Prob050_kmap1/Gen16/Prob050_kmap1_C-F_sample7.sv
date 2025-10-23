module TopModule(
    input logic a,  // Explicitly declare input signals as logic type for clarity.
    input logic b,
    input logic c,
    output logic out  // Declare the output signal as logic type for clarity and maintainability.
);

// Directly implement the Karnaugh map's logic using a combination of logical operators.
assign out = a | (b & c) | (b & ~c) | (~b & c);

endmodule