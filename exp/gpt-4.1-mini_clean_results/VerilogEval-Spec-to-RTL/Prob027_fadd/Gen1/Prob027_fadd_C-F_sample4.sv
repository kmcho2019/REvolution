module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // Sum is XOR of all three inputs
    assign sum = a ^ b ^ cin;

    // Carry-out is majority: true if at least two inputs are 1
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule