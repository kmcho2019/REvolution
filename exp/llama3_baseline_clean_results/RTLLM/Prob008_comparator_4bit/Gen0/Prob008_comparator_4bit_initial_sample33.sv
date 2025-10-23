module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    // Perform subtraction A - B and generate borrow
    wire [3:0] diff;
    wire borrow;

    // Ripple-borrow subtractor implementation
    assign diff[0] = A[0] ^ B[0] ^ borrow;
    assign borrow = (A[0] == 0 && B[0] == 1) || 
                    (A[0] == 0 && B[0] == 0 && borrow) || 
                    (A[0] == 1 && B[0] == 1 && borrow);

    assign diff[1] = A[1] ^ B[1] ^ borrow;
    assign borrow = (A[1] == 0 && B[1] == 1) || 
                    (A[1] == 0 && B[1] == 0 && borrow) || 
                    (A[1] == 1 && B[1] == 1 && borrow);

    assign diff[2] = A[2] ^ B[2] ^ borrow;
    assign borrow = (A[2] == 0 && B[2] == 1) || 
                    (A[2] == 0 && B[2] == 0 && borrow) || 
                    (A[2] == 1 && B[2] == 1 && borrow);

    assign diff[3] = A[3] ^ B[3] ^ borrow;

    // Determine A_greater, A_equal, and A_less based on subtraction result and borrow
    always @(*) begin
        if (borrow) begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end else if (diff!= 4'b0000) begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end else begin
            A_greater = 0;
            A_equal = 1;
            A_less = 0;
        end
    end

endmodule