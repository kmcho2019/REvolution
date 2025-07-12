module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

    // XOR gate to compute sum
    xor U1 (sum, a, b);

    // AND gate to compute carry out
    and U2 (cout, a, b);

endmodule