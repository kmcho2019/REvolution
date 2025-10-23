module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    // Divide the 64-bit inputs into four 16-bit segments
    wire [15:0] A_segment1, A_segment2, A_segment3, A_segment4;
    wire [15:0] B_segment1, B_segment2, B_segment3, B_segment4;
    assign A_segment1 = A[15:0];
    assign A_segment2 = A[31:16];
    assign A_segment3 = A[47:32];
    assign A_segment4 = A[63:48];
    assign B_segment1 = B[15:0];
    assign B_segment2 = B[31:16];
    assign B_segment3 = B[47:32];
    assign B_segment4 = B[63:48];

    // Perform subtraction on each segment
    wire [15:0] result_segment1, result_segment2, result_segment3, result_segment4;
    wire borrow1, borrow2, borrow3;
    assign {result_segment1, borrow1} = A_segment1 - B_segment1;
    assign {result_segment2, borrow2} = A_segment2 - B_segment2 - borrow1;
    assign {result_segment3, borrow3} = A_segment3 - B_segment3 - borrow2;
    assign {result_segment4, } = A_segment4 - B_segment4 - borrow3;

    // Combine the results of each segment to form the final 64-bit result
    assign result = {result_segment4, result_segment3, result_segment2, result_segment1};

    // Overflow detection logic
    always @(*) begin
        if ((A[63] == 1'b0 && B[63] == 1'b1 && result[63] == 1'b1) || (A[63] == 1'b1 && B[63] == 1'b0 && result[63] == 1'b0))
            overflow = 1'b1;
        else
            overflow = 1'b0;
    end

endmodule