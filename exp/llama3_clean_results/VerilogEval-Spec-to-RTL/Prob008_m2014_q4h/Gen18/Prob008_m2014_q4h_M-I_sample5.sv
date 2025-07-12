// TopModule: A simple module that assigns the input directly to the output.
module TopModule(
    // Input signal
    input  logic in,
    // Output signal
    output logic out
);
// Direct assignment of input to output
assign out = in;
endmodule