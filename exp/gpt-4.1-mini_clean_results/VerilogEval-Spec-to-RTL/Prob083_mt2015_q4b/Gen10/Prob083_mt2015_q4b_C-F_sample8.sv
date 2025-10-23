module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is high when inputs x and y are equal.
// This is implemented using the bitwise XNOR operator for optimal synthesis.
assign z = ~(x ^ y);

endmodule