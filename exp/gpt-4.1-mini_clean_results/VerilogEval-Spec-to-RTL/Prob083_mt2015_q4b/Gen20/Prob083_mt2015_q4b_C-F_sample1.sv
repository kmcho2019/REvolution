module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Output z is high (1) when inputs x and y are equal, i.e., z = x XNOR y
assign z = ~(x ^ y);

endmodule