module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

    // z is high when x and y are equal:
    // z = (~x & ~y) | (x & y) which is equivalent to XNOR of x and y
    assign z = ~(x ^ y);

endmodule