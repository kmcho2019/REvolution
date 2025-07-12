module TopModule (
    input  x,
    input  y,
    output z
);
    wire not_x, not_y;
    wire and1, and2;
    wire xor_xy;

    // Invert x and y
    assign not_x = ~x;
    assign not_y = ~y;

    // XOR implementation: (x & ~y) | (~x & y)
    assign and1 = x & not_y;
    assign and2 = not_x & y;
    assign xor_xy = and1 | and2;

    // Final output z = (x ^ y) & x
    assign z = xor_xy & x;
endmodule