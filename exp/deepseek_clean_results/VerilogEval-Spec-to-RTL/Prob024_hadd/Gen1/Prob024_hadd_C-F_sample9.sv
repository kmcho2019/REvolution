module TopModule (
    input  a,    // First input bit
    input  b,    // Second input bit
    output sum,  // Sum output (a XOR b)
    output cout  // Carry output (a AND b)
);
    // Half adder implementation
    assign sum = a ^ b;  // XOR operation for sum
    assign cout = a & b; // AND operation for carry-out
endmodule