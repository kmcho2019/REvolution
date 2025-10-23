module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    assign sum = a ^ b ^ cin; // XOR of a, b, and cin
    assign cout = (a & b) | (a & cin) | (b & cin); // Carry if at least two inputs are high

endmodule