module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wires for borrow and result of subtraction
wire [3:0] result;
wire [3:1] borrow;

// Perform subtraction and generate borrow for each bit position
full_subtractor fs0(A[0], B[0], 1'b0, result[0], borrow[1]);
full_subtractor fs1(A[1], B[1], borrow[1], result[1], borrow[2]);
full_subtractor fs2(A[2], B[2], borrow[2], result[2], borrow[3]);
full_subtractor fs3(A[3], B[3], borrow[3], result[3], borrow[4]);

// Determine if A is greater than B (no borrow and result is non-zero)
assign A_greater = (borrow[4] == 1'b0) && (|result);

// Determine if A is equal to B (result of subtraction is zero)
assign A_equal = ~(|result) && (borrow[4] == 1'b0);

// Determine if A is less than B (borrow occurred)
assign A_less = borrow[4];

endmodule

// Module for full subtractor
module full_subtractor(
    input A,
    input B,
    input borrow_in,
    output difference,
    output borrow_out
);

assign difference = A ^ B ^ borrow_in;
assign borrow_out = (~A & B) | (~A & borrow_in) | (B & borrow_in);

endmodule