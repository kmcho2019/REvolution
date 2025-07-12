module TopModule (
    input  wire x,
    input  wire y,
    output wire z
);
    wire xor_out;

    // XOR primitive for x ^ y
    xor (xor_out, x, y);

    // AND primitive for (x ^ y) & x
    and (z, xor_out, x);

endmodule