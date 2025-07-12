module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    wire [15:0] seg_A1, seg_A2, seg_A3, seg_A4;
    wire [15:0] seg_B1, seg_B2, seg_B3, seg_B4;
    wire [15:0] seg_result1, seg_result2, seg_result3, seg_result4;
    wire borrow1, borrow2, borrow3;
    reg [15:0] temp_result1, temp_result2, temp_result3, temp_result4;

    assign seg_A1 = A[15:0];
    assign seg_A2 = A[31:16];
    assign seg_A3 = A[47:32];
    assign seg_A4 = A[63:48];

    assign seg_B1 = B[15:0];
    assign seg_B2 = B[31:16];
    assign seg_B3 = B[47:32];
    assign seg_B4 = B[63:48];

    // Segment 1 subtraction
    assign temp_result1 = seg_A1 - seg_B1;
    assign borrow1 = (seg_A1 < seg_B1) ? 1 : 0;

    // Segment 2 subtraction with borrow
    assign temp_result2 = seg_A2 - seg_B2 - borrow1;
    assign borrow2 = (seg_A2 < (seg_B2 + borrow1)) ? 1 : 0;

    // Segment 3 subtraction with borrow
    assign temp_result3 = seg_A3 - seg_B3 - borrow2;
    assign borrow3 = (seg_A3 < (seg_B3 + borrow2)) ? 1 : 0;

    // Segment 4 subtraction with borrow
    assign temp_result4 = seg_A4 - seg_B4 - borrow3;

    // Overflow detection
    assign overflow = (A[63] != temp_result4[15]) && (A[63] != B[63]);

    // Combine segment results
    assign seg_result1 = temp_result1;
    assign seg_result2 = temp_result2;
    assign seg_result3 = temp_result3;
    assign seg_result4 = temp_result4;

    assign result = {seg_result4, seg_result3, seg_result2, seg_result1};

endmodule