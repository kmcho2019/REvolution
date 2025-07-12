module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    xor(sum, a, b);  // XOR operation for sum
    and(cout, a, b); // AND operation for carry-out
endmodule