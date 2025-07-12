module TopModule(
    input  in1,
    input  in2,
    output out
);

// The original implementation is already quite efficient
// assign out = ~(in1 | in2);

// Alternative implementation using a single NOR gate primitive (if available)
// assign out = ~(in1 | in2);

// Optimized implementation using the property of NOR gate
assign out = ~in1 & ~in2;

endmodule