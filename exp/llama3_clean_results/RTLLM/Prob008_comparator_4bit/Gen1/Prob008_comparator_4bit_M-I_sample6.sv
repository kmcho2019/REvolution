module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    // Subtraction result (4 bits)
    wire [3:0] diff;

    // Borrow signal (active-high when A < B)
    wire [3:0] borrow;

    // Perform 4-bit subtraction (A - B) with borrow
    assign diff[0] = A[0] ? (B[0] ? 0 : 1) : (B[0] ? 1 : 0);
    assign borrow[0] = (A[0] == 0 && B[0] == 1) ? 1 : 0;
    
    assign diff[1] = A[1] ? (B[1] ? (borrow[0] ? 0 : 1) : (borrow[0] ? 1 : 0)) : (B[1] ? (borrow[0] ? 1 : 0) : (borrow[0] ? 0 : 1));
    assign borrow[1] = ((A[1] == 0 && B[1] == 1) || (A[1] == 0 && B[1] == 0 && borrow[0] == 1)) ? 1 : 0;
    
    assign diff[2] = A[2] ? (B[2] ? (borrow[1] ? 0 : 1) : (borrow[1] ? 1 : 0)) : (B[2] ? (borrow[1] ? 1 : 0) : (borrow[1] ? 0 : 1));
    assign borrow[2] = ((A[2] == 0 && B[2] == 1) || (A[2] == 0 && B[2] == 0 && borrow[1] == 1)) ? 1 : 0;
    
    assign diff[3] = A[3] ? (B[3] ? (borrow[2] ? 0 : 1) : (borrow[2] ? 1 : 0)) : (B[3] ? (borrow[2] ? 1 : 0) : (borrow[2] ? 0 : 1));
    assign borrow[3] = ((A[3] == 0 && B[3] == 1) || (A[3] == 0 && B[3] == 0 && borrow[2] == 1)) ? 1 : 0;

    // Determine relationship based on borrow and result
    always @(A, B) begin
        if (borrow[3] == 1) begin
            A_greater = 0;
            A_equal = 0;
            A_less = 1;
        end
        else if (diff == 4'b0000) begin
            A_greater = 0;
            A_equal = 1;
            A_less = 0;
        end
        else begin
            A_greater = 1;
            A_equal = 0;
            A_less = 0;
        end
    end

endmodule