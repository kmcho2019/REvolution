module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output reg  [63:0] result,
    output reg         overflow
);

    // Internal signals for sign bits
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_result;

    always @(*) begin
        // Perform subtraction
        result = A - B;

        // Sign bit of result extracted from result[63]
        // Assign overflow based on the classic signed subtraction overflow condition
        overflow = (sign_A != sign_B) && (result[63] != sign_A);
    end

endmodule