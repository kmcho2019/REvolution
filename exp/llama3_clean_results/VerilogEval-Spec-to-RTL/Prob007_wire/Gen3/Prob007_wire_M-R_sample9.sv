// Define the TopModule with input and output ports.
module TopModule(
    input  logic in,  // Input signal
    output logic out   // Output signal
);

    // Continuous assignment: assign the input directly to the output.
    assign out = in;

endmodule