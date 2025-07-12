module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum is XOR of inputs
    assign sum = a ^ b;
    
    // Carry is AND of inputs
    assign cout = a & b;
endmodule