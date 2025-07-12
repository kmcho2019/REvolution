module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    assign sum = a ^ b ^ cin; // Sum is the XOR of a, b, and cin
    assign cout = (a & b) | (a & cin) | (b & cin); // Cout is the OR of (a AND b), (a AND cin), and (b AND cin)

endmodule