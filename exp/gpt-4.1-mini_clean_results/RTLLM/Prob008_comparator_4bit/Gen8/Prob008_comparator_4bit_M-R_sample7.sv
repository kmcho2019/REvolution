module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [4:0] borrow;

    // Initial borrow in is zero
    assign borrow[0] = 1'b0;

    // Ripple borrow chain for subtraction A - B
    assign borrow[1] = (~A[0] & B[0]) | (borrow[0] & ((~A[0]) | B[0]));
    assign borrow[2] = (~A[1] & B[1]) | (borrow[1] & ((~A[1]) | B[1]));
    assign borrow[3] = (~A[2] & B[2]) | (borrow[2] & ((~A[2]) | B[2]));
    assign borrow[4] = (~A[3] & B[3]) | (borrow[3] & ((~A[3]) | B[3]));

    // Equal if all bits match (XOR reduction)
    assign A_equal = ~( | (A ^ B) );

    // A is less if borrow out is 1
    assign A_less = borrow[4];

    // A greater if not less and not equal
    assign A_greater = ~(A_less | A_equal);

endmodule