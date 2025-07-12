module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    wire xor_ab;

    // Intermediate XOR of a and b
    assign xor_ab = a ^ b;

    // Sum is XOR of xor_ab and cin
    assign sum = xor_ab ^ cin;

    // Carry out uses optimized carry formula
    assign cout = (a & b) | (xor_ab & cin);

endmodule