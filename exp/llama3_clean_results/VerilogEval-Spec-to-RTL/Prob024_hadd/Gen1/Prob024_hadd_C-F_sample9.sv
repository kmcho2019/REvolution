module TopModule(
    input  a,  // Input bit a
    input  b,  // Input bit b
    output sum,  // Sum of a and b
    output cout  // Carry-out
);

// Calculate the sum using XOR operation because the sum is 1 only when a and b are different
assign sum = a ^ b;

// Calculate the carry-out using AND operation because a carry occurs only when both a and b are 1
assign cout = a & b;

endmodule