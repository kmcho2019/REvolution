module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    // Perform subtraction operation: A - B
    wire [3:0] diff;
    wire borrow;

    // Calculate difference and borrow
    assign diff[0] = A[0] - B[0];
    assign borrow = (A[0] < B[0]);
    assign diff[1] = A[1] - B[1] - borrow;
    assign borrow = (A[1] < B[1]) || (A[1] == B[1] && borrow);
    assign diff[2] = A[2] - B[2] - borrow;
    assign borrow = (A[2] < B[2]) || (A[2] == B[2] && borrow);
    assign diff[3] = A[3] - B[3] - borrow;

    // Determine outputs based on comparison result
    always @(*) begin
        if (borrow) begin
            // If borrow occurs, A is less than B
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end else if (diff != 0) begin
            // If no borrow and result is non-zero, A is greater than B
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end else begin
            // If no borrow and result is zero, A is equal to B
            A_greater = 0;
            A_equal = 1;
            A_less = 0;
        end
    end

endmodule