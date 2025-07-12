module TopModule (
    input a,       // First input bit
    input b,       // Second input bit
    output sum,    // Sum output (a XOR b)
    output cout    // Carry output (a AND b)
);

    // Sum is the XOR of inputs
    assign sum = a ^ b;
    // Carry is the AND of inputs
    assign cout = a & b;

endmodule