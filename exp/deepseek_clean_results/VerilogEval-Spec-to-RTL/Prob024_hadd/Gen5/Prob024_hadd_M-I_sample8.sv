module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Explicit gate instantiations
    xor U1(sum, a, b);
    and U2(cout, a, b);
endmodule