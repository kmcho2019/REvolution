module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is asserted (1) when inputs x and y are equal.
// This logic implements an XNOR gate using explicit bitwise operators:
// ~(x ^ y) ensures the synthesis tool maps this to a single XNOR gate,
// optimizing for area and performance.
assign z = ~(x ^ y);

endmodule