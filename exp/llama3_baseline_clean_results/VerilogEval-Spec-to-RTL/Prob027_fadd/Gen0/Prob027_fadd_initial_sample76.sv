module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    // Calculate sum bit using XOR operation
    assign sum = a ^ b ^ cin;

    // Calculate carry-out bit
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule