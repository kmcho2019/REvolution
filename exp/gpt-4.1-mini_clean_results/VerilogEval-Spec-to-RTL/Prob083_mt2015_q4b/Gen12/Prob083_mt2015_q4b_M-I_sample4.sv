module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);
    // Output z is high when both inputs are equal.
    assign z = (~x & ~y) | (x & y);
endmodule