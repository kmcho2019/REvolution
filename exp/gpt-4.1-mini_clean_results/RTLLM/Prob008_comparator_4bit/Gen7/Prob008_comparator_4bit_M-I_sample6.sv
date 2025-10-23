module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Intermediate borrows for subtraction A - B
    wire b0, b1, b2, b3;

    // bit 0 subtraction borrow: b0 = (~A[0] & B[0])
    assign b0 = (~A[0] & B[0]);

    // bit 1 subtraction borrow:
    // borrow occurs if previous borrow AND A[1] == 0 OR (~A[1] & B[1])
    assign b1 = ((~A[1] & B[1]) | (b0 & (~A[1] | B[1])));

    // bit 2 subtraction borrow:
    assign b2 = ((~A[2] & B[2]) | (b1 & (~A[2] | B[2])));

    // bit 3 subtraction borrow (MSB borrow out):
    assign b3 = ((~A[3] & B[3]) | (b2 & (~A[3] | B[3])));

    // Equality check: A == B if all bits equal
    // XOR reduction detects inequality; equality is negation of that
    wire any_bit_diff = |(A ^ B);
    assign A_equal = ~any_bit_diff;

    assign A_less = b3;

    // Since outputs are mutually exclusive:
    // A_greater = not less and not equal
    assign A_greater = ~b3 & A_equal ? 1'b0 : (~b3 & ~A_equal);

endmodule