module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Using primitive gate instantiations instead of operators
    xor G1(sum, a, b);
    and G2(cout, a, b);

endmodule