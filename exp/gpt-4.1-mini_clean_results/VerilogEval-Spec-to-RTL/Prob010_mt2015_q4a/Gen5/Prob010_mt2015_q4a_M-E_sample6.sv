module TopModule(
    input x,
    input y,
    output z
);
    wire xor_out;

    // XOR gate for (x ^ y)
    assign xor_out = x ^ y;

    // AND gate for (xor_out & x)
    assign z = xor_out & x;

endmodule