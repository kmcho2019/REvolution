// TopModule: A simple 2-input AND gate
module TopModule(
    input  a,  // First input
    input  b,  // Second input
    output out  // Output of the AND operation
);

// Directly assign the result of a AND b to out
assign out = a & b;

endmodule