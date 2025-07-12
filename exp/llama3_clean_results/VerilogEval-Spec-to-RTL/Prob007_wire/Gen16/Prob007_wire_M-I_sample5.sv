// Improved version of TopModule with enhanced comments for readability
module TopModule(
    // Input signal
    input  logic in,
    // Output signal directly connected to input
    output logic out
);
    // Assign input to output, implementing a wire-like behavior
    assign out = in;
endmodule