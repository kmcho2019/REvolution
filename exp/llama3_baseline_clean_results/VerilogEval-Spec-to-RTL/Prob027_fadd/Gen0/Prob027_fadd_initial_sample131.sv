module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    assign sum = a ^ b ^ cin; // XOR operation for sum
    assign cout = (a & b) | (a & cin) | (b & cin); // carry-out if at least two inputs are 1

endmodule