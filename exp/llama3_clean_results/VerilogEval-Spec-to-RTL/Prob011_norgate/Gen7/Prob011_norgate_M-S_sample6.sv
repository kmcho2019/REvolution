// Module TopModule implements a NOR gate.
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    output out  // Output signal out
);

assign out = ~(a | b);  // Direct NOR operation implementation

endmodule