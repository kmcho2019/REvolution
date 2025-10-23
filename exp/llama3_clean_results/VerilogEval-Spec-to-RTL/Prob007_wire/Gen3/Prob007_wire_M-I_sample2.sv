// TopModule: A module that behaves like a wire, directly assigning the input to the output.
module TopModule(
    // Input signal
    input  logic in,
    // Output signal, equivalent to the input
    output logic out
);

// Directly assign the input to the output to behave like a wire
assign out = in;

endmodule