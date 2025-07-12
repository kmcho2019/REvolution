module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);
    // Output z is high when inputs x and y are equal (both 0 or both 1)
    // Equivalent to XNOR: (x & y) | (~x & ~y)
    // This explicit form may help some synthesis tools optimize differently,
    // but functionally it's identical to the XNOR operator.
    assign z = (x & y) | (~x & ~y);
endmodule