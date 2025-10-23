module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is high when inputs x and y are equal.
// This is implemented as the XNOR of x and y for optimal synthesis and minimal hardware.
assign z = ~(x ^ y);

endmodule