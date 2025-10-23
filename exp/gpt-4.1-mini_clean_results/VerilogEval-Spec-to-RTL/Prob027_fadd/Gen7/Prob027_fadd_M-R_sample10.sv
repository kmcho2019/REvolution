module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // Sum is XOR of all three inputs
    assign sum = a ^ b ^ cin;
    // Carry-out is generated if any two or more inputs are high
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule