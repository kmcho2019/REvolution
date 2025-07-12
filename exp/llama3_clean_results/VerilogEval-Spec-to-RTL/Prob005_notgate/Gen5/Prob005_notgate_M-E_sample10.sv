// Novel NOT gate implementation using a multiplexer
module TopModule(
    input  logic in,  // Input signal
    output logic out  // Output signal
);

// Internal signal for the inverted input
logic inverted_in;

// Invert the input signal
assign inverted_in = ~in;

// Use a multiplexer to select the inverted input
// The control signal is fixed to 1, always selecting the inverted input
assign out = (1) ? inverted_in : in;

endmodule