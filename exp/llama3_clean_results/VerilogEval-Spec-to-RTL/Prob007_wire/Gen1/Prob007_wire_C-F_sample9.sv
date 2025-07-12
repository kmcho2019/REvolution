// TopModule: A simple Verilog module that behaves like a wire.
// It directly assigns the input signal to the output signal without any modification.

module TopModule(
    input  in,  // Input signal
    output out  // Output signal
);

// Continuous assignment statement to assign input to output
assign out = in;

endmodule