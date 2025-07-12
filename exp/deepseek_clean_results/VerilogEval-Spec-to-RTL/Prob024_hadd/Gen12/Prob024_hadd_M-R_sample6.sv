module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Explicit gate instantiations
    xor G1(sum, a, b);  // XOR gate for sum
    and G2(cout, a, b); // AND gate for carry-out
endmodule