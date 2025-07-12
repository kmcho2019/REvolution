module sub_64bit(
    input  wire [63:0] A,
    input  wire [63:0] B,
    output reg  [63:0] result,
    output reg         overflow
);

    reg [15:0] segment_A [3:0];
    reg [15:0] segment_B [3:0];
    reg [15:0] segment_result [3:0];
    reg [3:0] borrow;

    always @(*) begin
        // Divide the 64-bit operands into four 16-bit segments
        segment_A[0] = A[15:0];
        segment_A[1] = A[31:16];
        segment_A[2] = A[47:32];
        segment_A[3] = A[63:48];

        segment_B[0] = B[15:0];
        segment_B[1] = B[31:16];
        segment_B[2] = B[47:32];
        segment_B[3] = B[63:48];

        // Perform the subtraction operation on each segment
        segment_result[0] = segment_A[0] - segment_B[0];
        borrow[0] = (segment_A[0] < segment_B[0]) ? 1 : 0;

        segment_result[1] = segment_A[1] - segment_B[1] - borrow[0];
        borrow[1] = (segment_A[1] < (segment_B[1] + borrow[0])) ? 1 : 0;

        segment_result[2] = segment_A[2] - segment_B[2] - borrow[1];
        borrow[2] = (segment_A[2] < (segment_B[2] + borrow[1])) ? 1 : 0;

        segment_result[3] = segment_A[3] - segment_B[3] - borrow[2];

        // Combine the segment results to form the final result
        result[15:0] = segment_result[0];
        result[31:16] = segment_result[1];
        result[47:32] = segment_result[2];
        result[63:48] = segment_result[3];

        // Perform overflow detection
        if (A[63] == B[63] && A[63] != result[63]) begin
            overflow = 1'b1;
        end else begin
            overflow = 1'b0;
        end
    end

endmodule