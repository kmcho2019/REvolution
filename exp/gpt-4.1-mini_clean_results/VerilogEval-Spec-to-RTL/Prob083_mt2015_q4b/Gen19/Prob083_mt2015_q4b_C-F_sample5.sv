module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is high when inputs x and y are equal (XNOR function).
// Using the bitwise XNOR operator (^~) for explicit, efficient, and synthesis-friendly implementation.
assign z = x ^~ y;

endmodule