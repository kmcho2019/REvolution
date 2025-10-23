module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    // Divide the 64-bit operands into four 16-bit segments
    wire [15:0] A_segment1 = A[15:0];
    wire [15:0] A_segment2 = A[31:16];
    wire [15:0] A_segment3 = A[47:32];
    wire [15:0] A_segment4 = A[63:48];

    wire [15:0] B_segment1 = B[15:0];
    wire [15:0] B_segment2 = B[31:16];
    wire [15:0] B_segment3 = B[47:32];
    wire [15:0] B_segment4 = B[63:48];

    // Perform subtraction on each segment
    wire [15:0] result_segment1;
    wire [15:0] result_segment2;
    wire [15:0] result_segment3;
    wire [15:0] result_segment4;

    assign result_segment1 = A_segment1 - B_segment1;
    assign result_segment2 = A_segment2 - B_segment2;
    assign result_segment3 = A_segment3 - B_segment3;
    assign result_segment4 = A_segment4 - B_segment4;

    // Combine the results from each segment
    assign result = {result_segment4, result_segment3, result_segment2, result_segment1};

    // Overflow detection logic for each segment
    wire overflow_segment1 = (A_segment1[15]!= result_segment1[15]) && (A_segment1[15]!= B_segment1[15]);
    wire overflow_segment2 = (A_segment2[15]!= result_segment2[15]) && (A_segment2[15]!= B_segment2[15]);
    wire overflow_segment3 = (A_segment3[15]!= result_segment3[15]) && (A_segment3[15]!= B_segment3[15]);
    wire overflow_segment4 = (A_segment4[15]!= result_segment4[15]) && (A_segment4[15]!= B_segment4[15]);

    // Combine the overflow signals from each segment
    assign overflow = overflow_segment1 || overflow_segment2 || overflow_segment3 || overflow_segment4;

endmodule