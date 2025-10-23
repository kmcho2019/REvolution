module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Internal wires for subtraction result and borrow
    wire [3:0] result;
    wire [3:0] borrow;

    // Perform subtraction (A - B) and generate borrow
    full_subtractor fs0(A[0], B[0], 1'b0, result[0], borrow[0]);
    full_subtractor fs1(A[1], B[1], borrow[0], result[1], borrow[1]);
    full_subtractor fs2(A[2], B[2], borrow[1], result[2], borrow[2]);
    full_subtractor fs3(A[3], B[3], borrow[2], result[3], borrow[3]);

    // Determine output based on result and borrow
    assign A_less  = borrow[3]; // If a borrow occurs at the most significant bit, A is less than B
    assign A_equal = (~|result) & (~borrow[3]); // If result is zero and no borrow, A is equal to B
    assign A_greater = ~A_less & ~A_equal; // If neither less nor equal, A is greater than B

endmodule

// Full subtractor module
module full_subtractor(
    input  a,
    input  b,
    input  borrow_in,
    output result,
    output borrow_out
);
    assign result    = a ^ b ^ borrow_in;
    assign borrow_out = (b & ~a) | (b & borrow_in) | (~a & borrow_in);
endmodule