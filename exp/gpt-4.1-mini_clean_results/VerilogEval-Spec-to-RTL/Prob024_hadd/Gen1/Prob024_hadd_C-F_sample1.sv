module TopModule (
    input  a,      // Input bit a
    input  b,      // Input bit b
    output sum,    // Sum output: XOR of a and b
    output cout    // Carry out: AND of a and b
);
    // Sum is XOR of inputs
    assign sum = a ^ b;

    // Carry-out is AND of inputs
    assign cout = a & b;
endmodule