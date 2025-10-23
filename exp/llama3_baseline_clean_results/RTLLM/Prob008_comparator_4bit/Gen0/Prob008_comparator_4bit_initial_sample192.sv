module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg    A_greater,
    output reg    A_equal,
    output reg    A_less
);

    // Perform subtraction operation: A - B
    wire [3:0] result;
    assign result = A - B;

    // Check for borrow (A < B)
    wire borrow;
    assign borrow = (A[3] == 0 && B[3] == 1) || 
                    (A[3] == 1 && B[3] == 1 && A[2:0] < B[2:0]) ||
                    (A[3] == 0 && B[3] == 0 && A[2:0] < B[2:0]);

    // Determine outputs based on result and borrow
    always @(A, B) begin
        if (borrow) begin
            A_greater <= 1'b0;
            A_equal <= 1'b0;
            A_less <= 1'b1;
        end else if (result == 0) begin
            A_greater <= 1'b0;
            A_equal <= 1'b1;
            A_less <= 1'b0;
        end else begin
            A_greater <= 1'b1;
            A_equal <= 1'b0;
            A_less <= 1'b0;
        end
    end

endmodule