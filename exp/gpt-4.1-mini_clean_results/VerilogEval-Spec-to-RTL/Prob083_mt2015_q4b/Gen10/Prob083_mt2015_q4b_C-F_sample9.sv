module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is high when x and y are equal:
// i.e., z = 1 if (x == y), else z = 0.
// Implemented using the XNOR operator (~^),
// which is the simplest representation of equality.
assign z = x ~^ y;

endmodule