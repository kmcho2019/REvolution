module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

// Calculate sum using XOR operation (a XOR b)
// This operation follows the binary addition rule where:
// - 0 + 0 = 0
// - 0 + 1 = 1
// - 1 + 0 = 1
// - 1 + 1 = 10 (where 0 is the sum and 1 is the carry)
assign sum = a ^ b;

// Calculate carry-out using AND operation (a AND b)
// This operation follows the binary addition rule where a carry occurs only when both input bits are 1
assign cout = a & b;

endmodule