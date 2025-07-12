module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Direct implementation of half-adder equations
    // Sum is XOR of inputs (a ⊕ b)
    assign sum = a ^ b;
    
    // Carry is AND of inputs (a ∧ b)
    assign cout = a & b;
endmodule