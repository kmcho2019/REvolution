module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

// Calculate the sum as the XOR of a and b
assign sum = a ^ b;

// Calculate the carry-out as the AND of a and b
assign cout = a & b;

endmodule