module TopModule (
    input  wire a,  // Input signal a
    input  wire b,  // Input signal b
    input  wire c,  // Input signal c
    output wire w,  // Output connected to a
    output wire x,  // Output connected to b
    output wire y,  // Output connected to b
    output wire z   // Output connected to c
);

// Direct wire connections from inputs to outputs
assign w = a;
assign x = b;
assign y = b;
assign z = c;

endmodule