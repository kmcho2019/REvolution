// TopModule: A simple module that assigns the input value to the output.
module TopModule(
    input  in,  // Input signal
    output out  // Output signal, directly assigned the value of 'in'
);

// Continuous assignment statement to directly connect input to output.
assign out = in;

endmodule