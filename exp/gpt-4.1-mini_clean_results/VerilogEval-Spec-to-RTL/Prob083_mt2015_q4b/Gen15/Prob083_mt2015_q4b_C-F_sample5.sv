module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is high when inputs x and y are equal.
// Implemented explicitly as bitwise XNOR (~(x ^ y)) to clearly convey the intended logic,
// which synthesis tools efficiently map to a dedicated XNOR gate.
// This form is also functionally equivalent to (x == y) and aids maintainability and clarity.
assign z = ~(x ^ y);

endmodule