module TopModule(
    input  a,  // First input bit
    input  b,  // Second input bit
    output sum,  // Sum of the two input bits
    output cout  // Carry-out of the addition
);

// Calculate the sum using an XOR operation
// The XOR operation results in 1 if the input bits are different
assign sum = a ^ b;

// Calculate the carry-out using an AND operation
// The AND operation results in 1 if both input bits are 1
assign cout = a & b;

endmodule