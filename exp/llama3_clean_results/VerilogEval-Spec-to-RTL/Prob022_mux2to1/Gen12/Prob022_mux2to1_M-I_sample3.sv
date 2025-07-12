module TopModule(
    input  logic a, // Declare inputs as 'logic' for clarity and to specify their type explicitly
    input  logic b,
    input  logic sel,
    output logic out // Declare output as 'logic' for clarity
);

// Use the ternary operator for direct and efficient implementation of the multiplexer
assign out = sel ? b : a;

endmodule