module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Instantiate primitive gates
    xor sum_gate(sum, a, b);
    and carry_gate(cout, a, b);

endmodule