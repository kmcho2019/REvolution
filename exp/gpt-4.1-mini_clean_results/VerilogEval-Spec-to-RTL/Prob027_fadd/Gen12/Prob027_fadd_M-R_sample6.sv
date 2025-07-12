module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    // Full adder sum is XOR of all three inputs
    assign sum = a ^ b ^ cin;

    // Carry out is when any two or more inputs are high
    assign cout = (a & b) | (b & cin) | (cin & a);

endmodule