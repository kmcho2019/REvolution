module TopModule (
    input  x,
    input  y,
    output z
);

    // Intermediate signal for clarity
    wire xor_xy = x ^ y;

    // Output z is the boolean function: (x XOR y) AND x
    assign z = xor_xy & x;

endmodule