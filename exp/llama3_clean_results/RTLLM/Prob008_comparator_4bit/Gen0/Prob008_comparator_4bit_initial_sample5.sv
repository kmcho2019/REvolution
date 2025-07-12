module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,   // 1-bit output indicating if A is equal to B
    output A_less    // 1-bit output indicating if A is less than B
);

// Perform subtraction A - B using addition with inverted B and carry-in = 1
// This is done in two steps for clarity: 
// 1. Invert B
// 2. Add A to the inverted B with a carry-in of 1

wire [3:0] not_B;  // Inverted B
assign not_B = ~B;

wire [3:0] result;  // Result of the subtraction A - B
wire borrow;  // Indicates if a borrow occurred (A less than B)

// Using an adder with carry for the subtraction operation
full_adder fa0(A[0], not_B[0], 1, result[0], borrow);
full_adder fa1(A[1], not_B[1], borrow, result[1], borrow);
full_adder fa2(A[2], not_B[2], borrow, result[2], borrow);
full_adder fa3(A[3], not_B[3], borrow, result[3], borrow);

// Determine outputs based on the result of subtraction
assign A_greater = ~borrow & ~(|result);  // A greater than B if no borrow and result is not zero
assign A_equal = ~borrow & ~(|result);  // A equal to B if no borrow and result is zero
assign A_less = borrow;  // A less than B if a borrow occurred

// Implement the full adder
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

endmodule