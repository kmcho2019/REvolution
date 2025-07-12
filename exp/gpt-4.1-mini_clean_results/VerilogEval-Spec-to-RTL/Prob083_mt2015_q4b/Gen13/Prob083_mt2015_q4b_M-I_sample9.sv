module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is high when inputs x and y are equal.
// Explicit bitwise XNOR implemented as ~(x ^ y) to guide synthesis.
assign z = ~(x ^ y);

endmodule