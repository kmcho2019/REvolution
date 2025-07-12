module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum output: XOR of inputs (a + b without carry)
    assign sum = a ^ b;
    
    // Carry output: AND of inputs (carry generation)
    assign cout = a & b;
endmodule