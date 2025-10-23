module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    wire [3:0] diff;
    wire borrow;

    // Perform subtraction A - B
    assign diff[0] = A[0] ^ B[0] ^ borrow;
    assign diff[1] = A[1] ^ B[1] ^ borrow;
    assign diff[2] = A[2] ^ B[2] ^ borrow;
    assign diff[3] = A[3] ^ B[3] ^ borrow;

    // Generate borrow
    assign borrow = (A[0] == 1'b0 && B[0] == 1'b1) || 
                    (A[1] == 1'b0 && B[1] == 1'b1 && A[0] == B[0]) || 
                    (A[2] == 1'b0 && B[2] == 1'b1 && A[1:0] == B[1:0]) || 
                    (A[3] == 1'b0 && B[3] == 1'b1 && A[2:0] == B[2:0]);

    // Determine A_greater, A_equal, A_less
    always @(*) begin
        if (borrow) begin
            A_less = 1'b1;
            A_equal = 1'b0;
            A_greater = 1'b0;
        end else if (diff == 4'b0000) begin
            A_less = 1'b0;
            A_equal = 1'b1;
            A_greater = 1'b0;
        end else begin
            A_less = 1'b0;
            A_equal = 1'b0;
            A_greater = 1'b1;
        end
    end

endmodule