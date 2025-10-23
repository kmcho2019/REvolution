module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    // Sum is XOR of all three inputs
    assign sum = a ^ b ^ cin;

    // Carry out using alternative reduced form
    assign cout = (a & b) | ((a ^ b) & cin);

endmodule