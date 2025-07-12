module TopModule (
    input  x,
    input  y,
    output z
);
    wire xor_out;

    // Instantiate XOR gate for x ^ y
    xor u_xor (xor_out, x, y);

    // Instantiate AND gate for (x ^ y) & x
    and u_and (z, xor_out, x);
endmodule