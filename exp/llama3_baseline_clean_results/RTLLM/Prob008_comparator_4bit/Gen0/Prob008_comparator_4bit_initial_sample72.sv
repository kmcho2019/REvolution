module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [3:0] diff;
    wire borrow;

    // Perform subtraction A - B
    assign diff[0] = A[0]? (B[0]? 1'b0 : 1'b1) : (B[0]? 1'b1 : 1'b0);
    assign diff[1] = A[1]? (B[1]? 1'b0 : 1'b1) : (B[1]? (A[0]? 1'b0 : 1'b1) : 1'b0);
    assign diff[2] = A[2]? (B[2]? 1'b0 : 1'b1) : (B[2]? (A[1] && A[0]? 1'b0 : (A[1]? 1'b1 : 1'b0)) : 1'b0);
    assign diff[3] = A[3]? (B[3]? 1'b0 : 1'b1) : (B[3]? (A[2] && A[1] && A[0]? 1'b0 : (A[2] && A[1]? 1'b1 : (A[2]? 1'b1 : 1'b0))) : 1'b0);

    assign borrow = (A[0] == 1'b0 && B[0] == 1'b1) || 
                    (A[1] == 1'b0 && B[1] == 1'b1 && (A[0] == 1'b1)) || 
                    (A[2] == 1'b0 && B[2] == 1'b1 && (A[1] == 1'b1 && A[0] == 1'b1)) || 
                    (A[3] == 1'b0 && B[3] == 1'b1 && (A[2] == 1'b1 && A[1] == 1'b1 && A[0] == 1'b1));

    // Determine the outputs based on the result of subtraction
    assign A_greater = ~borrow && (diff!= 4'b0000);
    assign A_equal = ~borrow && (diff == 4'b0000);
    assign A_less = borrow;

endmodule