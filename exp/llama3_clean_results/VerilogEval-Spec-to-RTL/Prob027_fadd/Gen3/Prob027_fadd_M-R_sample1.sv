module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    // Intermediate wires for carry calculation
    wire ab; // a AND b
    wire ac; // a AND cin
    wire bc; // b AND cin

    assign ab = a & b;
    assign ac = a & cin;
    assign bc = b & cin;

    // Sum and carry-out calculations
    assign sum = a ^ b ^ cin;
    assign cout = ab | ac | bc;

endmodule