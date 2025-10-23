module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

// Combinational continuous assignment: output z is high when x equals y (XNOR)
assign z = ~(x ^ y);

endmodule