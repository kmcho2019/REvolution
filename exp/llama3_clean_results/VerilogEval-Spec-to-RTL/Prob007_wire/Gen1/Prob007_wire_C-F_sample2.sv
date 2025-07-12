// Module: TopModule
// Description: A simple module that behaves like a wire, directly assigning the input to the output.
module TopModule(
    input  in,  // Input signal
    output out  // Output signal, directly assigned from input
);

// Continuous assignment statement to assign input to output
assign out = in;

endmodule