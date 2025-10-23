module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is 1 when x and y are equal (XNOR)
assign z = x ~^ y;

endmodule