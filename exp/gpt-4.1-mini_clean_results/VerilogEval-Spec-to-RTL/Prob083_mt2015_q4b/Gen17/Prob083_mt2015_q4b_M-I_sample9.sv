module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

assign z = ~(x ^ y);  // z = 1 when x == y, else 0

endmodule