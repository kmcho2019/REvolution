module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is high when inputs x and y are equal.
// This corresponds to XNOR behavior: z = ~(x ^ y).
assign z = (x == y);

endmodule