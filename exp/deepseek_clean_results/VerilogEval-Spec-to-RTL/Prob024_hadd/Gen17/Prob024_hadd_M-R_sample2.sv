module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Sum is XOR of inputs (standard half-adder sum)
    assign sum = a ^ b;
    
    // Carry is AND of inputs (standard half-adder carry)
    assign cout = a & b;

endmodule