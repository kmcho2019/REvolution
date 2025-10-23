// comparator_4bit module implementation
module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // Output indicating if A is greater than B
    output A_equal,    // Output indicating if A is equal to B
    output A_less      // Output indicating if A is less than B
);

// Internal wires for borrow and result
wire [3:0] result;
wire [3:1] borrow;

// Perform subtraction A - B using full subtractor logic
full_subtractor fs0(A[0], B[0], 1'b0, result[0], borrow[1]);
full_subtractor fs1(A[1], B[1], borrow[1], result[1], borrow[2]);
full_subtractor fs2(A[2], B[2], borrow[2], result[2], borrow[3]);
full_subtractor fs3(A[3], B[3], borrow[3], result[3], borrow[0]);  // No use of borrow out of most significant bit

// Determine comparison result based on borrow and result of subtraction
assign A_greater = ~borrow[0] & ~(|result);  // If no borrow and result is not zero, A is greater than B
assign A_equal = ~borrow[0] & ~(|result) == 1'b0 & ~(|result) == 1'b0;  // If no borrow and result is zero, A is equal to B
assign A_less = borrow[0];  // If borrow occurs, A is less than B

// Full subtractor module
module full_subtractor(
    input a,
    input b,
    input borrow_in,
    output result,
    output borrow_out
);
    assign result = a ^ b ^ borrow_in;
    assign borrow_out = (~a & b) | (b & borrow_in) | (~a & borrow_in);
endmodule

endmodule