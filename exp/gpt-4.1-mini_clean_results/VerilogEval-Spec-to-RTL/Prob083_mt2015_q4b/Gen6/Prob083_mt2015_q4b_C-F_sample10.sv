module TopModule (
    input  x,
    input  y,
    output z
);

// Output z is high when x and y are equal (XNOR)
assign z = x ~^ y;

endmodule