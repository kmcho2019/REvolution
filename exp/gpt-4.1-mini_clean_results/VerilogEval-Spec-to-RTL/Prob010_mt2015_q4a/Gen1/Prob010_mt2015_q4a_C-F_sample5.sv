module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);

    // Output z is the boolean function: (x XOR y) AND x
    assign z = (x ^ y) & x;

endmodule