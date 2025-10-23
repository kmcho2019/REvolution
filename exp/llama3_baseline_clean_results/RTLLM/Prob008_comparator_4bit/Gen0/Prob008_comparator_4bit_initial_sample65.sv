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

    assign diff[0] = A[0] - B[0];
    assign diff[1] = A[1] - B[1] - borrow;
    assign diff[2] = A[2] - B[2] - borrow;
    assign diff[3] = A[3] - B[3] - borrow;

    assign borrow = (A[0] < B[0]) | ((A[0] == B[0]) & (A[1] < B[1])) | ((A[0] == B[0]) & (A[1] == B[1]) & (A[2] < B[2])) | ((A[0] == B[0]) & (A[1] == B[1]) & (A[2] == B[2]) & (A[3] < B[3]));

    // Analyze the result of the subtraction operation
    always @(*) begin
        if (borrow) begin
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end else if (diff == 4'b0000) begin
            A_greater = 1'b0;
            A_equal = 1'b1;
            A_less = 1'b0;
        end else begin
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end
    end

endmodule