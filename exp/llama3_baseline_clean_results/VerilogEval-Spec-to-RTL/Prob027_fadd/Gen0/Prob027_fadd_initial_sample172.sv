module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

assign sum = a ^ b ^ cin; // XOR of a, b, and cin gives the sum
assign cout = (a & b) | (a & cin) | (b & cin); // Carry-out is 1 if any two or all three of a, b, cin are 1

endmodule