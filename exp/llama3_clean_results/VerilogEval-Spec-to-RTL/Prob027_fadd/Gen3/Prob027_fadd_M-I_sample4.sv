module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    // Calculate the sum using XOR operation
    assign sum = a ^ b ^ cin;

    // Calculate the carry-out using AND and OR operations
    // The expression (a & b) | (a & cin) | (b & cin) directly implements the carry logic
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule