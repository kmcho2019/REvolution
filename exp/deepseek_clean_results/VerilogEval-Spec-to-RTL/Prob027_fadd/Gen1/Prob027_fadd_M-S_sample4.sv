module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    wire a_xor_b = a ^ b;

    // Sum is the XOR of a_xor_b and cin
    assign sum = a_xor_b ^ cin;

    // Carry-out is 1 if both a and b are 1, or if (a or b) and cin are 1
    assign cout = (a & b) | (a_xor_b & cin);

endmodule