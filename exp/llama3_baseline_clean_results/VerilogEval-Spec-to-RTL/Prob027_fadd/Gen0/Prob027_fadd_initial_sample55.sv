module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

// Implement the sum bit using XOR operation
assign sum = a ^ b ^ cin;

// Implement the carry-out bit using AND-OR operation
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule