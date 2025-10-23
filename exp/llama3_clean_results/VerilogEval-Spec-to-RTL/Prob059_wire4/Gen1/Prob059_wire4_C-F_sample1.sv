// TopModule is designed to behave like a set of wires, connecting inputs directly to outputs.
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    input  c,  // Input signal c
    output w,  // Output signal w, connected to input a
    output x,  // Output signal x, connected to input b
    output y,  // Output signal y, connected to input b
    output z   // Output signal z, connected to input c
);

// Use continuous assignment to directly connect inputs to outputs.
assign w = a;  // Connect input a to output w
assign x = b;  // Connect input b to output x
assign y = b;  // Connect input b to output y
assign z = c;  // Connect input c to output z

endmodule