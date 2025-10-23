// TopModule: A simple Verilog module that behaves like a wire.
// It takes one input and passes it directly to the output without modification.

module TopModule(
    input  logic in,  // Input signal
    output logic out   // Output signal
);

    // Direct continuous assignment for wire-like behavior
    assign out = in;

endmodule