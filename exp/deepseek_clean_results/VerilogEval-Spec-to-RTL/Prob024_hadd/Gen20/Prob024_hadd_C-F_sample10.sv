module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Optimal implementation combining both approaches
    // Sum is XOR of inputs (direct implementation)
    assign sum = a ^ b;
    
    // Carry is AND of inputs (direct implementation)
    assign cout = a & b;
endmodule