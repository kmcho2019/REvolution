module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Internal signal to store the result of subtraction
    wire [3:0] diff;

    // Perform subtraction: A - B
    assign diff[0] = A[0] ? (B[0] ? 1'b0 : 1'b1) : (B[0] ? 1'b1 : 1'b0);
    assign diff[1] = A[1] ? (B[1] ? (A[0] ? 1'b0 : 1'b1) : 1'b1) : (B[1] ? (A[0] ? 1'b1 : 1'b0) : 1'b0);
    assign diff[2] = A[2] ? (B[2] ? (A[1] ? (A[0] ? 1'b0 : 1'b1) : 1'b1) : 1'b1) : (B[2] ? (A[1] ? (A[0] ? 1'b1 : 1'b0) : 1'b0) : 1'b0);
    assign diff[3] = A[3] ? (B[3] ? (A[2] ? (A[1] ? (A[0] ? 1'b0 : 1'b1) : 1'b1) : 1'b1) : 1'b1) : (B[3] ? (A[2] ? (A[1] ? (A[0] ? 1'b1 : 1'b0) : 1'b0) : 1'b0) : 1'b0);

    // Check if A is greater than B
    assign A_greater = (diff[3] && ~diff[2] && ~diff[1] && ~diff[0]) || 
                      (~diff[3] && diff[2] && ~diff[1] && ~diff[0]) || 
                      (~diff[3] && ~diff[2] && diff[1] && ~diff[0]) || 
                      (~diff[3] && ~diff[2] && ~diff[1] && diff[0]);

    // Check if A is equal to B
    assign A_equal = ~diff[3] && ~diff[2] && ~diff[1] && ~diff[0];

    // Check if A is less than B
    assign A_less = (~diff[3] && diff[2]) || 
                   (~diff[3] && ~diff[2] && diff[1]) || 
                   (~diff[3] && ~diff[2] && ~diff[1] && diff[0]);

endmodule