module TopModule (
    input  a,    // First input
    input  b,    // Second input
    output out   // Output: AND of a and b
);

// Continuous assignment implements 2-input AND gate.
// This approach is minimal and optimal for combinational logic.
assign out = a & b;

endmodule