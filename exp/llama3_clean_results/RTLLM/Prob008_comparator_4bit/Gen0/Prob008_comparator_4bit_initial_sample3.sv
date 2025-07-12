module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Intermediate wires for borrow and result
    wire [3:0] result;
    wire [3:0] borrow;

    // Perform subtraction A - B
    assign {borrow[3], result[3]} = A[3] - B[3];
    assign {borrow[2], result[2]} = A[2] - B[2] - borrow[3];
    assign {borrow[1], result[1]} = A[1] - B[1] - borrow[2];
    assign {borrow[0], result[0]} = A[0] - B[0] - borrow[1];

    // Determine A_greater
    assign A_greater = (borrow[3] == 0) && (result!= 4'b0000);

    // Determine A_equal
    assign A_equal = (borrow[3] == 0) && (result == 4'b0000);

    // Determine A_less
    assign A_less = borrow[3];

endmodule