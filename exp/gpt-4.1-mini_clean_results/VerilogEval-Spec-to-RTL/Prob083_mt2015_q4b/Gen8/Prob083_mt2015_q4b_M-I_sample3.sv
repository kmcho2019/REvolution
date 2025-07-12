module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);
    // Output z is high when inputs x and y are equal (both 0 or both 1).
    // Equivalent to XNOR: (x & y) | (~x & ~y).
    assign z = (x & y) | (~x & ~y);
endmodule