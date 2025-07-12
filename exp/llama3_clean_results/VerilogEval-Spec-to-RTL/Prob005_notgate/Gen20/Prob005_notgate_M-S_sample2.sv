// TopModule: A simplified Verilog module implementing a NOT gate.
module TopModule(
    input  in,  // Input signal to be inverted
    output out  // Output signal, inverted version of input
);

    // Directly assign the inverted input to the output
    assign out = ~in;

endmodule