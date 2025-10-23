// Improved module with explicit type declaration for the output signal as wire.
module TopModule(
    input logic a,  // Input signals as logic type.
    input logic b,
    input logic c,
    output wire out  // Output signal declared as wire for potential synthesis optimization.
);

// The logic remains the same, using a continuous assignment for the OR operation.
assign out = a | b | c;

endmodule