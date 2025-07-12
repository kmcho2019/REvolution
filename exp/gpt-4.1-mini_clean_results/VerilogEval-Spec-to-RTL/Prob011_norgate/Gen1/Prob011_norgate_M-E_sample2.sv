module TopModule(
    input a,
    input b,
    output out
);
    wire not_a, not_b;

    // Invert inputs using NAND gates
    nand (not_a, a, a);
    nand (not_b, b, b);

    // NAND the inverted inputs to get NOR output
    nand (out, not_a, not_b);
endmodule