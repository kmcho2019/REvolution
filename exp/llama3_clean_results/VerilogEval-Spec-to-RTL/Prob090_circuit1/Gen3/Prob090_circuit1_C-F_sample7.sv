// TopModule implements a simple AND gate.
// The output q is 1 only when both inputs a and b are 1.
module TopModule(
    input  a,  // Input a
    input  b,  // Input b
    output q   // Output q
);

// Assign statement to implement the AND logic
assign q = a & b;

endmodule