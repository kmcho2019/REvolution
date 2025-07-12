module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is high when x equals y (XNOR function)
assign z = x ~^ y;

endmodule