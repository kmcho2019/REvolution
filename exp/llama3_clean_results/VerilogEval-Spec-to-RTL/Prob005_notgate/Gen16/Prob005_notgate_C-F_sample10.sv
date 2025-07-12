// Module: TopModule
// Description: Implements a NOT gate.
module TopModule(
    input  in,  // Input signal
    output out  // Output signal
);
    // Directly assign the inverted input to the output
    // This is the most efficient way to implement a NOT gate in Verilog
    assign out = ~in;
endmodule