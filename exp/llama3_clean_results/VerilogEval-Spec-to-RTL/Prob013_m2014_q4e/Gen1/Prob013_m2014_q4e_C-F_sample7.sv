// TopModule: A Verilog module implementing a 2-input NOR gate.
module TopModule(
    input  in1,  // First input signal
    input  in2,  // Second input signal
    output nor_out  // Output signal representing the NOR of in1 and in2
);

// The NOR gate is implemented using the logical NOT operator (~) and the logical OR operator (|).
// The expression ~(in1 | in2) evaluates to 1 only if both in1 and in2 are 0.
assign nor_out = ~(in1 | in2);

endmodule