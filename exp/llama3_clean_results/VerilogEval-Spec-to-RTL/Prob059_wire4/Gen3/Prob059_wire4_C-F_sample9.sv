// Module TopModule: A simple module that behaves like wires, connecting inputs directly to outputs.
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    input  c,  // Input signal c
    output wire w,  // Output signal w, connected to input a
    output wire x,  // Output signal x, connected to input b
    output wire y,  // Output signal y, connected to input b
    output wire z  // Output signal z, connected to input c
);

// Always block with sensitivity to all inputs to mimic wire behavior
always @(*) begin
    // Direct assignments to output signals based on input signals
    w = a;  // Connect input a to output w
    x = b;  // Connect input b to output x
    y = b;  // Connect input b to output y
    z = c;  // Connect input c to output z
end

endmodule