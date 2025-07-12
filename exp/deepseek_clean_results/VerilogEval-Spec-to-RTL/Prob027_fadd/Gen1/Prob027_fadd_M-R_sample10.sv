module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    wire a_xor_b;

    // Intermediate XOR result
    assign a_xor_b = a ^ b;

    // Sum is XOR of intermediate result with cin
    assign sum = a_xor_b ^ cin;

    // Carry-out uses intermediate result and original inputs
    assign cout = (a & b) | (a_xor_b & cin);

endmodule